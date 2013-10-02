//
//  TentClient.m
//  TentClient
//
//  Created by Jesse Stuart on 8/10/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TentClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLResponseSerialization.h"
#import "HTTPLinkHeader.h"
#import "HTMLLink.h"
#import "NSJSONSerialization+ObjectCleanup.h"
#import "NSString+Parser.h"
#import "HawkAuth.h"
#import "WebViewController.h"
#import "NSURL+QueryStringEncoding.h"

@implementation TentClient

+ (instancetype)clientWithEntity:(NSURL *)entityURI {
    TentClient *client = [[TentClient alloc] init];

    client.entityURI = entityURI;

    return client;
}

#pragma mark - Discovery

- (void)performDiscoveryWithSuccessBlock:(void (^)())success failureBlock:(void (^)())failure {
    [self performHEADDiscoveryWithSuccessBlock:^{
        [self fetchMetaPostWithSuccessBlock:^{
            // Successfully fetched meta post
            success();
        } failureBlock:^{
            // Failed to fetch meta post
            failure();
        }];
    } failureBlock:^{
        // HEAD discovery failed

        [self performGETDiscoveryWithSuccessBlock:^{
            [self fetchMetaPostWithSuccessBlock:^{
                // Successfully fetched meta post
                success();
            } failureBlock:^{
                // Failed to fetch meta post
                failure();
            }];
        } failureBlock:^{
            // GET discovery failed

            failure();
        }];
    }];
}

- (void)performHEADDiscoveryWithSuccessBlock:(void (^)())success failureBlock:(void (^)())failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.entityURI];
    [request setHTTPMethod: @"HEAD"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    // Disable default behaviour to use basic auth
    operation.shouldUseCredentialStorage = NO;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id __unused responseObject) {
        NSString *linkHeader = [[operation.response allHeaderFields] valueForKey:@"Link"];

        HTTPLinkHeader *metaPostLink = [self parseLinkHeader:linkHeader matchingRel:@"https://tent.io/rels/meta-post" fromURL:[operation.response valueForKey:@"URL"]];

        if (!metaPostLink) {
            failure();
            return;
        }

        self.metaPostURL = metaPostLink.URL;

        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    
    [operation start];
}

- (void)performGETDiscoveryWithSuccessBlock:(void (^)())success failureBlock:(void (^)())failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.entityURI];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    // Disable default behaviour to use basic auth
    operation.shouldUseCredentialStorage = NO;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id __unused responseObject) {
        HTMLLink *metaPostLink = [self parseHTMLLink:operation.responseString fromURL:[operation.response valueForKey:@"URL"]];

        if (!metaPostLink) {
            failure();
            return;
        }

        self.metaPostURL = metaPostLink.URL;

        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    
    [operation start];
}

- (void)fetchMetaPostWithSuccessBlock:(void (^)())success failureBlock:(void (^)())failure {
    if (!self.metaPostURL) {
        failure();
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.metaPostURL];
    AFHTTPRequestOperation *operation = [self requestOperationWithURLRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!operation.response.statusCode == 200) {
            failure();
            return;
        }

        id responseJSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        if (![responseJSON isKindOfClass:[NSMutableDictionary class]]) {
            // Expected an NSMutableDictionary
            failure();
            return;
        }

        NSError *error;
        self.metaPost = [MTLJSONAdapter modelOfClass:[TCPost class] fromJSONDictionary:[responseJSON objectForKey:@"post"] error:&error];

        if (error) {
            failure();

            NSLog(@"failed deserialize TCPost: %@", error);

            return;
        }

        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];

    [operation start];
}

- (HTTPLinkHeader *)parseLinkHeader:(NSString *)linkHeader matchingRel:(NSString *)rel fromURL:(NSURL *)originURL {
    NSArray *links = [HTTPLinkHeader parseLinks:linkHeader];

    NSUInteger index = [links indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        HTTPLinkHeader * link = obj;
        return [[link.attribtues valueForKey:@"rel"] isEqualToString:rel];
    }];

    if (index == NSNotFound) {
        return NULL;
    }

    HTTPLinkHeader *metaPostLink = [links objectAtIndex:index];

    if (!metaPostLink.URL.scheme) {
        metaPostLink.URL = [NSURL URLWithString:[metaPostLink.URL absoluteString] relativeToURL:originURL];
    }

    return metaPostLink;
}

- (HTMLLink *)parseHTMLLink:(NSString *)htmlString fromURL:(NSURL *)originURL {
    NSArray *links = [HTMLLink parseLinks:htmlString];

    NSUInteger index = [links indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        HTMLLink * link = obj;
        return [[link.attribtues valueForKey:@"rel"] isEqualToString:@"https://tent.io/rels/meta-post"];
    }];

    if (index == NSNotFound) {
        return NULL;
    }

    HTMLLink *metaPostLink = [links objectAtIndex:index];

    if (!metaPostLink.URL.scheme) {
        metaPostLink.URL = [NSURL URLWithString:[metaPostLink.URL absoluteString] relativeToURL:originURL];
    }

    return metaPostLink;
}

#pragma mark - OAuth

- (void)authenticateWithApp:(TCAppPost *)appPost successBlock:(void (^)(TCAppPost *, TCAuthPost *))success failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *))failure viewController:(UIViewController *)controller {
    // Ensure we have the meta post
    if (!self.metaPost) {
        return [self performDiscoveryWithSuccessBlock:^{
            [self authenticateWithApp:appPost successBlock:success failureBlock:failure viewController:controller];
        } failureBlock:^{
            NSError *error = [NSError errorWithDomain:TCDiscoveryFailureErrorDomain code:1 userInfo:nil];
            failure(nil, error);
        }];
    }

    // Create app post
    if (!appPost.ID) {
        NSLog(@"create app post: %@", appPost.ID);
        return [self newPost:appPost successBlock:^(AFHTTPRequestOperation *operation, TCPost *post) {
            NSError *error;
            if (![[NSNumber numberWithInteger:operation.response.statusCode] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                error = [NSError errorWithDomain:TCInvalidResponseCodeErrorDomain code:operation.response.statusCode userInfo:nil];
                failure(operation, error);
                return;
            }

            // Fetch linked credentials post
            NSString *linkHeader = [[operation.response allHeaderFields] valueForKey:@"Link"];

            HTTPLinkHeader *appCredentialsLink = [self parseLinkHeader:linkHeader matchingRel:@"https://tent.io/rels/credentials" fromURL:[operation.response valueForKey:@"URL"]];

            if (!appCredentialsLink) {
                error = [NSError errorWithDomain:TCInvalidLinkHeaderErrorDomain code:1 userInfo:nil];
                failure(operation, error);
                return;
            }

            [self getPostFromURL:appCredentialsLink.URL successBlock:^(AFHTTPRequestOperation *operation, TCPost *appCredentialsPost) {
                ((TCAppPost *)post).credentialsPost = (TCCredentialsPost *)appCredentialsPost;
                [self authenticateWithApp:(TCAppPost *)post successBlock:success failureBlock:failure viewController:controller];
            } failureBlock:failure];
        } failureBlock:failure];
    }

    // Ensure app post exists
    if ([[[NSDate alloc] init] timeIntervalSince1970] - [appPost.clientReceivedAt timeIntervalSince1970] > 60) {
        // App post received by client more than a minute ago

        // Fetch app post
        return [self getPostWithEntity:[appPost.entityURI absoluteString] postID:appPost.ID successBlock:^(AFHTTPRequestOperation *operation, TCPost *post) {
            NSError *error;
            if (![[NSNumber numberWithInteger:operation.response.statusCode] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                error = [NSError errorWithDomain:TCInvalidResponseCodeErrorDomain code:operation.response.statusCode userInfo:nil];
                failure(operation, error);
                return;
            }

            // TODO: Fetch app credentials post

            NSLog(@"fetched app post: %@", post);

            [self authenticateWithApp:(TCAppPost *)post successBlock:success failureBlock:failure viewController:controller];
        } failureBlock:failure];
    }

    // Build OAuth redirect URI
    NSString *state = [self randomStringOfLength:[NSNumber numberWithInteger:32]];
    NSURL *oauthRedirectURI = [[self.metaPost preferredServer] oauthAuthURLWithAppID:appPost.ID state:state];

    // Open oauthRedirectURI in a UIWebView
    WebViewController *webViewController = [[WebViewController alloc] init];

    [controller presentViewController:webViewController animated:YES completion:^{
        [webViewController loadRequest:[NSURLRequest requestWithURL:oauthRedirectURI] withCompletionBlock:^(NSURLRequest *request) {
            if ([[request.URL absoluteString] hasPrefix:[appPost.redirectURI absoluteString]]) {
                [controller dismissViewControllerAnimated:YES completion:^{
                    NSDictionary *params = [request.URL parseQueryString];
                    if (![[params objectForKey:@"state"] isEqualToString:state]) {
                        failure(nil, [NSError errorWithDomain:TCOAuthStateMismatchErrorDomain code:1 userInfo:@{ @"params": params }]);
                        return;
                    }

                    if ([params objectForKey:@"error"]) {
                        failure(nil, [NSError errorWithDomain:TCOAuthErrorErrorDomain code:1 userInfo:@{ @"params": params }]);
                        return;
                    }

                    [self exchangeTokenForApp:appPost tokenCode:[params objectForKey:@"code"] successBlock:success failureBlock:failure];
                }];
            }
        }];
    }];

    // TODO: Add ability to close webview

    // TODO: Open link in default browser on desktop
}

- (void)exchangeTokenForApp:(TCAppPost *)appPost tokenCode:(NSString *)tokenCode successBlock:(void (^)(TCAppPost *, TCAuthPost *))success failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[self.metaPost preferredServer] oauthTokenURL]];
    [request setHTTPMethod:@"POST"];

    // Set request body
    NSError *serializationError;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:@{ @"code": tokenCode, @"token_type": @"https://tent.io/oauth/hawk-token" } options:0 error:&serializationError];

    if (serializationError) {
        failure(nil, serializationError);
        return;
    }

    [request setHTTPBody:requestData];

    // Set Content-Type
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // Set Accept
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    // Authenticate request using app credentials
    TentClient *appClient = [TentClient clientWithEntity:self.entityURI];
    appClient.metaPost = self.metaPost;
    appClient.credentialsPost = appPost.credentialsPost;

    NSURLRequest *authedRequest = [appClient authenticateRequest:request];

    AFHTTPRequestOperation *operation = [self requestOperationWithURLRequest:authedRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        if (![[NSNumber numberWithInteger:operation.response.statusCode] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            error = [NSError errorWithDomain:TCInvalidResponseCodeErrorDomain code:operation.response.statusCode userInfo:nil];
            failure(operation, error);
            return;
        }

        id responseJSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        if (![responseJSON isKindOfClass:[NSMutableDictionary class]]) {
            error = [NSError errorWithDomain:TCInvalidResponseBodyErrorDomain code:1 userInfo:nil];
            failure(operation, error);
            return;
        }

        TCCredentialsPost *authCredentialsPost = [[TCCredentialsPost alloc] init];
        authCredentialsPost.ID = [responseJSON objectForKey:@"access_token"];
        authCredentialsPost.key = [responseJSON objectForKey:@"hawk_key"];
        authCredentialsPost.algorithm = CryptoAlgorithmSHA256; // sha256 is currently the only supported algorithm

        self.credentialsPost = authCredentialsPost;

        success(appPost, nil);
    } failure:failure];

    [operation start];
}

#pragma mark - API Endpoints

- (void)newPost:(TCPost *)post successBlock:(void (^)(AFHTTPRequestOperation *operation, TCPost *post))success failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[self.metaPost preferredServer] newPostURL]];
    [request setHTTPMethod: @"POST"];

    // Set request body
    NSError *serializationError;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:[post serializeJSONObject] options:0 error:&serializationError];

    if (serializationError) {
        failure(nil, serializationError);
        return;
    }

    [request setHTTPBody:requestData];

    // Set Content-Type
    [request addValue:[NSString stringWithFormat:@"application/vnd.tent.post.v0+json; type=\"%@\"", post.typeURI] forHTTPHeaderField:@"Content-Type"];

    // Authenticate request
    NSURLRequest *authedRequest = [self authenticateRequest:request];

    AFHTTPRequestOperation *operation = [self requestOperationWithURLRequest:authedRequest];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id __unused responseObject) {
        NSError *error;
        if (![[NSNumber numberWithInteger:operation.response.statusCode] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            error = [NSError errorWithDomain:TCInvalidResponseCodeErrorDomain code:operation.response.statusCode userInfo:nil];
            failure(operation, error);
            return;
        }

        id responseJSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        if (![responseJSON isKindOfClass:[NSMutableDictionary class]]) {
            error = [NSError errorWithDomain:TCInvalidResponseBodyErrorDomain code:1 userInfo:nil];
            failure(operation, error);
            return;
        }

        TCPost *_post = [MTLJSONAdapter modelOfClass:[TCPost class] fromJSONDictionary:[responseJSON objectForKey:@"post"] error:&error];

        if (error) {
            failure(operation, error);
            
            return;
        }

        success(operation, _post);
    } failure:failure];
    
    [operation start];
}

- (void)getPostWithEntity:(NSString *)entity postID:(NSString *)postID successBlock:(void (^)(AFHTTPRequestOperation *operation, TCPost *post))success failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSURL *postURL = [[self.metaPost preferredServer] postURLWithEntity:entity postID:postID];

    [self getPostFromURL:postURL successBlock:success failureBlock:failure];
}

- (void)getPostFromURL:(NSURL *)postURL successBlock:(void (^)(AFHTTPRequestOperation *operation, TCPost *post))success failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSURLRequest *request;

    if (![[postURL parameterString] firstIndexOf:@"bewit="]) {
        // Request does not use bewit authentication
        // Add authorization header

        request = [self authenticateRequest:[NSURLRequest requestWithURL:postURL]];
    } else {
        request = [NSURLRequest requestWithURL:postURL];
    }

    AFHTTPRequestOperation *operation = [self requestOperationWithURLRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id __unused responseObject) {
        NSError *error;
        if (!operation.response.statusCode == 200) {
            error = [NSError errorWithDomain:TCInvalidResponseCodeErrorDomain code:operation.response.statusCode userInfo:@{ @"operation": operation }];
            failure(operation, error);
            return;
        }

        id responseJSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        if (![responseJSON isKindOfClass:[NSMutableDictionary class]]) {
            error = [NSError errorWithDomain:TCInvalidResponseBodyErrorDomain code:1 userInfo:@{ @"operation": operation }];
            failure(operation, error);
            return;
        }

        TCPost *_post = [MTLJSONAdapter modelOfClass:[TCPost class] fromJSONDictionary:[responseJSON objectForKey:@"post"] error:&error];

        if (error) {
            failure(operation, error);

            return;
        }

        success(operation, _post);
    } failure:failure];

    [operation start];
}

#pragma mark - Authentication

- (NSURLRequest *)authenticateRequest:(NSURLRequest *)request {
    if (!self.credentialsPost) {
        return request;
    }

    HawkAuth *auth = [[HawkAuth alloc] init];

    auth.credentials = [[HawkCredentials alloc] initWithHawkId:self.credentialsPost.ID withKey:self.credentialsPost.key withAlgorithm:self.credentialsPost.algorithm];

    auth.contentType = [[request allHTTPHeaderFields] valueForKey:@"Content-Type"];

    auth.payload = [request HTTPBody];

    auth.method = [request HTTPMethod];

    if ([[request.URL scheme] isEqualToString:@"https"]) {
        auth.port = [NSNumber numberWithInteger:443];
    } else if ([[request.URL scheme] isEqualToString:@"http"]) {
        auth.port = [NSNumber numberWithInteger:80];
    } else {
        auth.port = [request.URL port];
    }

    auth.host = [request.URL host];

    auth.requestUri = [request.URL path];

    auth.nonce = [self randomStringOfLength:[NSNumber numberWithInt:6]];

    auth.timestamp = [[NSDate alloc] init];

    NSString *authorizationHeader = [[auth requestHeader] substringFromIndex:15]; // Remove @"Authorization: " prefix

    NSMutableURLRequest *authedRequest = (NSMutableURLRequest *)(request);
    [authedRequest addValue:authorizationHeader forHTTPHeaderField:@"Authorization"];

    return (NSURLRequest *)authedRequest;
}

-(NSString *)randomStringOfLength:(NSNumber *)length {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity:[length integerValue]];

    for (int i=0; i<[length integerValue]; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }

    return randomString;
}

- (AFHTTPRequestOperation *)requestOperationWithURLRequest:(NSURLRequest *)request {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    // Disable default behaviour to use basic auth
    operation.shouldUseCredentialStorage = NO;

    return operation;
}

@end

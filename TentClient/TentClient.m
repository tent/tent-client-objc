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

        HTTPLinkHeader *metaPostLink = [self parseLinkHeader:linkHeader fromURL:[operation.response valueForKey:@"URL"]];

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

- (HTTPLinkHeader *)parseLinkHeader:(NSString *)linkHeader fromURL:(NSURL *)originURL {
    NSArray *links = [HTTPLinkHeader parseLinks:linkHeader];

    NSUInteger index = [links indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        HTTPLinkHeader * link = obj;
        return [[link.attribtues valueForKey:@"rel"] isEqualToString:@"https://tent.io/rels/meta-post"];
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

- (void)authenticateWithApp:(TCAppPost *)appPost successBlock:(void (^)(TCAppPost *, TCAuthPost *))success failureBlock:(void (^)(NSError *))failure {
    // Ensure we have the meta post
    if (!self.metaPost) {
        return [self performDiscoveryWithSuccessBlock:^{
            [self authenticateWithApp:appPost successBlock:success failureBlock:failure];
        } failureBlock:^{
            NSError *error = [NSError errorWithDomain:TCDiscoveryFailureErrorDomain code:1 userInfo:nil];
            failure(error);
        }];
    }

    if (!appPost.ID) {
        return [self newPost:appPost successBlock:^(AFHTTPRequestOperation *operation, TCPost *post) {
            [self authenticateWithApp:(TCAppPost *)post successBlock:success failureBlock:failure];
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }

}

#pragma mark - API Endpoints

- (void)newPost:(TCPost *)post successBlock:(void (^)(AFHTTPRequestOperation *operation, TCPost *post))success failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[self.metaPost preferredServer] newPostURL]];
    [request setHTTPMethod: @"POST"];

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

- (AFHTTPRequestOperation *)requestOperationWithURLRequest:(NSURLRequest *)request {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    // Disable default behaviour to use basic auth
    operation.shouldUseCredentialStorage = NO;

    return operation;
}

@end

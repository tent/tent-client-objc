//
//  TentClient.h
//  TentClient
//
//  Created by Jesse Stuart on 8/10/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import "Foundation/Foundation.h"
#import "TCPost.h"
#import "TCMetaPost.h"
#import "TCAppPost.h"
#import "TCAuthPost.h"
#import "AFHTTPRequestOperation.h"
#import "TCParams.h"
#import "TCResponseEnvelope.h"

static NSString *const TCInvalidResponseCodeErrorDomain =
    @"Invalid Response Code";
static NSString *const TCInvalidResponseBodyErrorDomain =
    @"Invalid Response Body";
static NSString *const TCDiscoveryFailureErrorDomain = @"Discovery Failure";
static NSString *const TCOAuthStateMismatchErrorDomain =
    @"OAuth State Mismatch";
static NSString *const TCOAuthErrorErrorDomain = @"OAuth Error";
static NSString *const TCInvalidLinkHeaderErrorDomain = @"Invalid Link Header";
static NSString *const TCOAuthUserAbortErrorDomain = @"OAuth User Abort";
static NSString *const TCInvalidMetaPostURLErrorDomain =
    @"Invalid Meta Post URL";
static NSString *const TCInvalidMetaPostLinkErrorDomain =
    @"Invalid Meta Post Link";

@interface TentClient : NSObject

@property(nonatomic) NSURL *entityURI;

@property(nonatomic) NSURL *metaPostURL;

@property(nonatomic) TCMetaPost *metaPost;

@property(nonatomic) TCCredentialsPost *credentialsPost;

@property(nonatomic) NSOperationQueue *operationQueue;

+ (instancetype)clientWithEntity:(NSURL *)entityURI;

#pragma mark - Discovery

- (void)performDiscoveryWithSuccessBlock:
        (void (^)(AFHTTPRequestOperation *operation))success
                            failureBlock:
                                (void (^)(AFHTTPRequestOperation *operation,
                                          NSError *error))failure;

- (void)performHEADDiscoveryWithSuccessBlock:
        (void (^)(AFHTTPRequestOperation *operation))success
                                failureBlock:
                                    (void (^)(AFHTTPRequestOperation *operation,
                                              NSError *error))failure;

- (void)performGETDiscoveryWithSuccessBlock:
        (void (^)(AFHTTPRequestOperation *operation))success
                               failureBlock:
                                   (void (^)(AFHTTPRequestOperation *operation,
                                             NSError *error))failure;

- (void)fetchMetaPostWithSuccessBlock:
        (void (^)(AFHTTPRequestOperation *operation))success
                         failureBlock:
                             (void (^)(AFHTTPRequestOperation *operation,
                                       NSError *error))failure;

#pragma mark - OAuth

/*
 - Performs discovery on entity unless metaPost present
 - Creates app if needed
 - Calls success or failure block
 */
- (void)registerApp:(TCAppPost *)appPost
       successBlock:(void (^)(TCAppPost *appPost,
                              TCCredentialsPost *authCredentialsPost))success
       failureBlock:
           (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 - Registers app
 - Calls failure block if app registration fails
 - Calls success block with URI to open in browser and state for user
 authentication

 App is expected to use a custom URL scheme for the callback URI
 and open OAuth URL in the users's default browser.
 */
- (void)authenticateWithApp:(TCAppPost *)appPost
               successBlock:(void (^)(TCAppPost *appPost, NSURL *authURI,
                                      NSString *state))success
               failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                      NSError *error))failure;

/*
 - Parses token code and state params from callback URI
 - Verifies state
 - Performs token exchange
 - Calls success or failure block
 */
- (void)exchangeTokenForApp:(TCAppPost *)appPost
                callbackURI:(NSURL *)callbackURI
                      state:(NSString *)state
               successBlock:
                   (void (^)(TCAppPost *appPost,
                             TCCredentialsPost *authCredentialsPost))success
               failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                      NSError *error))failure;

/*
 - Performs token exchange
 - Calls success or failure block
 */
- (void)exchangeTokenForApp:(TCAppPost *)appPost
                  tokenCode:(NSString *)tokenCode
               successBlock:(void (^)(TCAppPost *, TCCredentialsPost *))success
               failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                      NSError *error))failure;

#pragma mark - API Endpoints

// new_post

- (void)newPost:(TCPost *)post
    successBlock:
        (void (^)(AFHTTPRequestOperation *operation, TCPost *post))success
    failureBlock:
        (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// post

- (void)getPostWithEntity:(NSString *)entity
                   postID:(NSString *)postID
             successBlock:(void (^)(AFHTTPRequestOperation *operation,
                                    TCPost *post))success
             failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                    NSError *error))failure;

- (void)getPostFromURL:(NSURL *)postURL
          successBlock:
              (void (^)(AFHTTPRequestOperation *operation, TCPost *post))success
          failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                 NSError *error))failure;

- (void)deletePostWithEntity:(NSString *)entity
                      postID:(NSString *)postID
                successBlock:
                    (void (^)(AFHTTPRequestOperation *operation))success
                failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                       NSError *error))failure;

- (void)deletePostWithURL:(NSURL *)postURL
             successBlock:(void (^)(AFHTTPRequestOperation *operation))success
             failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                    NSError *error))failure;

// attachment

- (void)getAttachmentWithEntity:(NSString *)entity
                         digest:(NSString *)digest
                   successBlock:(void (^)(AFHTTPRequestOperation *operation,
                                          NSData *attachmentBinary))success
                   failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                          NSError *error))failure;

- (void)getAttachmentFromURL:(NSURL *)attachmentURL
                successBlock:(void (^)(AFHTTPRequestOperation *operation,
                                       NSData *attachmentBinary))success
                failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                       NSError *error))failure;

// posts_feed

- (void)postsFeedWithParams:(TCParams *)params
               successBlock:
                   (void (^)(AFHTTPRequestOperation *operation,
                             TCResponseEnvelope *responseEnvelope))success
               failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                      NSError *error))failure;

- (void)postsFeedWithURL:(NSURL *)postsFeedURL
            successBlock:(void (^)(AFHTTPRequestOperation *,
                                   TCResponseEnvelope *))success
            failureBlock:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

#pragma mark - Authentication

- (NSURLRequest *)authenticateRequest:(NSURLRequest *)request;

- (NSString *)randomStringOfLength:(NSNumber *)length;

@end

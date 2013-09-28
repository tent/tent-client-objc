//
//  TentClient.h
//  TentClient
//
//  Created by Jesse Stuart on 8/10/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "Foundation/Foundation.h"
#import "TCPost.h"
#import "TCMetaPost.h"
#import "TCAppPost.h"
#import "TCAuthPost.h"

NSString * const TCInvalidResponseCodeErrorDomain;
NSString * const TCInvalidResponseBodyErrorDomain;
NSString * const TCDiscoveryFailureErrorDomain;

@interface TentClient : NSObject

@property (nonatomic) NSURL *entityURI;

@property (nonatomic) NSURL *metaPostURL;

@property (nonatomic) TCMetaPost *metaPost;

+ (instancetype)clientWithEntity:(NSURL *)entityURI;

#pragma mark - Discovery

- (void)performDiscoveryWithSuccessBlock:(void (^)())success
                            failureBlock:(void (^)())failure;

- (void)performHEADDiscoveryWithSuccessBlock:(void (^)())success
                                failureBlock:(void (^)())failure;

- (void)performGETDiscoveryWithSuccessBlock:(void (^)())success
                               failureBlock:(void (^)())failure;

- (void)fetchMetaPostWithSuccessBlock:(void (^)())success
                         failureBlock:(void (^)())failure;

#pragma mark - OAuth

/*
 - Performs discovery on entity unless metaPost present
 - Creates app when id absent
 - Opens webview for user authentication
 - Performs token exchange when token returned
 - Calls success or failure block
 */
- (void)authenticateWithApp:(TCAppPost *)appPost
               successBlock:(void (^)(TCAppPost *appPost, TCAuthPost *authPost))success
               failureBlock:(void (^)(NSError *error))failure;

@end

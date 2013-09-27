//
//  TentClient.h
//  TentClient
//
//  Created by Jesse Stuart on 8/10/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "Foundation/Foundation.h"

@interface TentClient : NSObject

@property (nonatomic) NSURL *entityURI;

@property (nonatomic) NSURL *metaPostURL;

@property (nonatomic) NSDictionary *metaPost;

+ (instancetype)clientWithEntity:(NSURL *)entityURI;

- (void)performDiscoveryWithSuccessBlock:(void (^)())success
                            failureBlock:(void (^)())failure;

- (void)performHEADDiscoveryWithSuccessBlock:(void (^)())success
                                failureBlock:(void (^)())failure;

- (void)performGETDiscoveryWithSuccessBlock:(void (^)())success
                               failureBlock:(void (^)())failure;

- (void)fetchMetaPostWithSuccessBlock:(void (^)())success
                         failureBlock:(void (^)())failure;

@end

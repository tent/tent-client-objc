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

+ (instancetype)clientWithEntity:(NSURL *)entityURI;

- (void)performDiscovery;

@end

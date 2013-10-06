//
//  TCMetaPost.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCPost.h"
#import "TCMetaPostServer.h"

@interface TCMetaPost : TCPost

@property (nonatomic) NSArray *servers;

@property (nonatomic) NSString *profileName;
@property (nonatomic) NSString *profileBio;
@property (nonatomic) NSURL *profileWebsite;
@property (nonatomic) NSString *profileLocation;

@property (nonatomic) NSURL *metaEntityURI;
@property (nonatomic) NSArray *previousEntities;

- (TCMetaPostServer *)preferredServer;
- (TCMetaPostServer *)preferredServerFromIndex:(NSNumber *)index;

@end

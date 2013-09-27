//
//  Post.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "Mantle.h"

@interface TCPost : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSDate *publishedAt;
@property (nonatomic) NSDate *receivedAt;
@property (nonatomic) NSDate *versionPublishedAt;
@property (nonatomic) NSDate *versionReceivedAt;

@property (nonatomic) NSString *versionID;
@property (nonatomic) NSArray *versionParents;

@property (nonatomic) NSString *ID;

@property (nonatomic) NSString *typeURI;

@property (nonatomic) NSArray *mentions;
@property (nonatomic) NSArray *refs;

@property (nonatomic) NSDictionary *content;

@property (nonatomic) BOOL permissionsPublic;
@property (nonatomic) NSArray *permissionsEntities;
@property (nonatomic) NSArray *permissionsGroups;

@end

//
//  Post.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import "Mantle.h"

@interface TCPost : MTLModel<MTLJSONSerializing>

@property(nonatomic) NSDate *clientReceivedAt;

@property(nonatomic) NSDate *publishedAt;
@property(nonatomic) NSDate *receivedAt;
@property(nonatomic) NSDate *versionPublishedAt;
@property(nonatomic) NSDate *versionReceivedAt;

@property(nonatomic) NSString *versionID;
@property(nonatomic) NSArray *versionParents;

@property(nonatomic) NSString *ID;

@property(nonatomic) NSURL *entityURI;

@property(nonatomic) NSString *typeURI;

@property(nonatomic) NSArray *mentions;
@property(nonatomic) NSArray *refs;

@property(nonatomic) NSDictionary *content;

@property(nonatomic) BOOL permissionsPublic;
@property(nonatomic) NSArray *permissionsEntities;
@property(nonatomic) NSArray *permissionsGroups;

@property(nonatomic) NSArray *attachments;

- (NSDictionary *)serializeJSONObject;

@end

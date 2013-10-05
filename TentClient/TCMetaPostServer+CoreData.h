//
//  TCMetaPostServer+CoreData.h
//  TentClient
//
//  Created by Jesse Stuart on 10/5/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCMetaPostServer.h"

@interface TCMetaPostServer (CoreData) <MTLManagedObjectSerializing>

@end

@interface TCMetaPostServerManagedObject : NSManagedObject

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext*)context;

@property (nonatomic) NSString *urlTemplateOAuthAuth;
@property (nonatomic) NSString *urlTemplateOAuthToken;
@property (nonatomic) NSString *urlTemplateNewPost;
@property (nonatomic) NSString *urlTemplatePostAttachment;
@property (nonatomic) NSString *urlTemplateAttachment;
@property (nonatomic) NSString *urlTemplateBatch;
@property (nonatomic) NSString *urlTemplatePostsFeed;
@property (nonatomic) NSString *urlTemplatePost;
@property (nonatomic) NSString *urlTemplateServerInfo;
@property (nonatomic) NSString *urlTemplateDiscover;

@property (nonatomic) NSString *protocolVersion;
@property (nonatomic) NSNumber *preferenceIndex;

@end

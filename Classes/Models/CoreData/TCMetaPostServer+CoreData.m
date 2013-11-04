//
//  TCMetaPostServer+CoreData.m
//  TentClient
//
//  Created by Jesse Stuart on 10/5/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCMetaPostServer+CoreData.h"

@implementation TCMetaPostServer (CoreData)

+ (NSString *)managedObjectEntityName {
    return @"TCMetaPostServer";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"urlTemplateAttachment": @"urlTemplateAttachment",
             @"urlTemplateBatch": @"urlTemplateBatch",
             @"urlTemplateDiscover": @"urlTemplateDiscover",
             @"urlTemplateNewPost": @"urlTemplateNewPost",
             @"urlTemplateOAuthAuth": @"urlTemplateOAuthAuth",
             @"urlTemplateOAuthToken": @"urlTemplateOAuthToken",
             @"urlTemplatePost": @"urlTemplatePost",
             @"urlTemplatePostAttachment": @"urlTemplatePostAttachment",
             @"urlTemplatePostsFeed": @"urlTemplatePostsFeed",
             @"urlTemplateServerInfo": @"urlTemplateServerInfo",
             @"protocolVersion": @"protocolVersion",
             @"preferenceIndex": @"preferenceIndex"
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithArray:[[self managedObjectKeysByPropertyKey] allKeys]];
}

@end

@implementation TCMetaPostServerManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)context {
	return [NSEntityDescription insertNewObjectForEntityForName:@"TCMetaPostServer" inManagedObjectContext:context];
}

@dynamic urlTemplateAttachment;
@dynamic urlTemplateBatch;
@dynamic urlTemplateDiscover;
@dynamic urlTemplateNewPost;
@dynamic urlTemplateOAuthAuth;
@dynamic urlTemplateOAuthToken;
@dynamic urlTemplatePost;
@dynamic urlTemplatePostAttachment;
@dynamic urlTemplatePostsFeed;
@dynamic urlTemplateServerInfo;

@dynamic protocolVersion;
@dynamic preferenceIndex;

@end

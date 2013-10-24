//
//  TCPost+CoreData.m
//  TentClient
//
//  Created by Jesse Stuart on 10/2/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCPost+CoreData.h"

@implementation TCPost (CoreData)

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"TCPost";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"clientReceivedAt": @"clientReceivedAt",
             @"publishedAt": @"publishedAt",
             @"receivedAt": @"receivedAt",
             @"versionPublishedAt": @"versionPublishedAt",
             @"versionReceivedAt": @"versionReceivedAt",
             @"ID": @"id",
             @"entityURI": @"entityURI",
             @"typeURI": @"typeURI",
             @"versionID": @"versionID",
             @"versionParents": @"versionParents",
             @"mentions": @"mentions",
             @"refs": @"refs",
             @"content": @"content",
             @"permissionsPublic": @"permissionsPublic",
             @"permissionsEntities": @"permissionsEntities",
             @"permissionsGroups": @"permissionsGroups",
             @"attachments": @"attachments"
             };
}

+ (NSValueTransformer *)entityAttributeTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"entityURI"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSURL *url) {
            return [url absoluteString];
        } reverseBlock:^id(NSString *urlStr) {
            return [NSURL URLWithString:urlStr];
        }];
    }

    return nil;
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObjects:@"ID", @"entityURI", nil];
}

@end

@implementation TCPostManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)context {
	return [NSEntityDescription insertNewObjectForEntityForName:@"TCPost" inManagedObjectContext:context];
}

@dynamic attachments;
@dynamic clientReceivedAt;
@dynamic content;
@dynamic entityURI;
@dynamic id;
@dynamic mentions;
@dynamic permissionsEntities;
@dynamic permissionsGroups;
@dynamic permissionsPublic;
@dynamic publishedAt;
@dynamic receivedAt;
@dynamic refs;
@dynamic typeURI;
@dynamic versionID;
@dynamic versionParents;
@dynamic versionPublishedAt;
@dynamic versionReceivedAt;

@end

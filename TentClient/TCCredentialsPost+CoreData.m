//
//  TCCredentialsPost+CoreData.m
//  TentClient
//
//  Created by Jesse Stuart on 10/2/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCCredentialsPost+CoreData.h"

@implementation TCCredentialsPost (CoreData)

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"TCCredentialsPost";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super managedObjectKeysByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary:@{
                                        @"content": NSNull.null,
                                        @"key": @"key",
                                        @"algorithm": @"algorithm"
                                        }];

    return [NSDictionary dictionaryWithDictionary:mapping];
}

@end

@implementation TCCredentialsPostManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)context {
	return [NSEntityDescription insertNewObjectForEntityForName:@"TCCredentialsPost" inManagedObjectContext:context];
}

@dynamic algorithm;
@dynamic attachments;
@dynamic clientReceivedAt;
@dynamic entityURI;
@dynamic id;
@dynamic key;
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
@dynamic appPost;

@end

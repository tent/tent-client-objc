//
//  TCMetaPost+CoreData.m
//  TentClient
//
//  Created by Jesse Stuart on 10/5/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCMetaPost+CoreData.h"
#import "TCMetaPostServer+CoreData.h"

@implementation TCMetaPost (CoreData)

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"TCMetaPost";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super managedObjectKeysByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary:@{
                                        @"content": NSNull.null,
                                        @"profileName": @"name",
                                        @"profileBio": @"bio",
                                        @"profileWebsite": @"website",
                                        @"profileLocation": @"location",
                                        @"metaEntityURI": @"metaEntity",
                                        @"previousEntities": @"previousEntities"
                                        }];

    return [NSDictionary dictionaryWithDictionary:mapping];
}

+ (NSValueTransformer *)entityAttributeTransformerForKey:(NSString *)key {
    if ([@[@"profileWebsite", @"metaEntityURI"] containsObject:key]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSURL *url) {
            return [url absoluteString];
        } reverseBlock:^id(NSString *urlStr) {
            return [NSURL URLWithString:urlStr];
        }];
    }

    return [super entityAttributeTransformerForKey:key];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey {
    return @{
             @"servers": TCMetaPostServerManagedObject.class
             };
}

@end

@implementation TCMetaPostManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)context {
	return [NSEntityDescription insertNewObjectForEntityForName:@"TCMetaPost" inManagedObjectContext:context];
}

@dynamic attachments;
@dynamic clientReceivedAt;
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

@dynamic name;
@dynamic bio;
@dynamic website;
@dynamic location;
@dynamic metaEntity;
@dynamic previousEntities;
@dynamic servers;

@end

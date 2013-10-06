//
//  TCAppPost+CoreData.m
//  TentClient
//
//  Created by Jesse Stuart on 10/2/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCAppPost+CoreData.h"
#import "TCCredentialsPost+CoreData.h"

@implementation TCAppPost (CoreData)

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"TCAppPost";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super managedObjectKeysByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary:@{
                                        @"content": NSNull.null,
                                        @"name": @"name",
                                        @"appDescription": @"appDescription",
                                        @"URL": @"url",
                                        @"redirectURI": @"redirectURI",
                                        @"notificationURL": @"notificationURL",
                                        @"notificationTypes": @"notificationTypes",
                                        @"readTypes": @"readTypes",
                                        @"writeTypes": @"writeTypes",
                                        @"scopes": @"scopes",
                                        }];

    return [NSDictionary dictionaryWithDictionary:mapping];
}

+ (NSValueTransformer *)entityAttributeTransformerForKey:(NSString *)key {
    if ([@[@"URL", @"redirectURI", @"notificationURL"] containsObject:key]) {
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
             @"credentialsPost": TCCredentialsPost.class,
             @"authCredentialsPost": TCCredentialsPost.class
             };
}

@end

@implementation TCAppPostManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)context {
	return [NSEntityDescription insertNewObjectForEntityForName:@"TCAppPost" inManagedObjectContext:context];
}

@dynamic appDescription;
@dynamic attachments;
@dynamic clientReceivedAt;
@dynamic entityURI;
@dynamic id;
@dynamic mentions;
@dynamic name;
@dynamic notificationTypes;
@dynamic notificationURL;
@dynamic permissionsEntities;
@dynamic permissionsGroups;
@dynamic permissionsPublic;
@dynamic publishedAt;
@dynamic readTypes;
@dynamic receivedAt;
@dynamic redirectURI;
@dynamic refs;
@dynamic scopes;
@dynamic typeURI;
@dynamic url;
@dynamic versionID;
@dynamic versionParents;
@dynamic versionPublishedAt;
@dynamic versionReceivedAt;
@dynamic writeTypes;
@dynamic credentialsPost;
@dynamic authCredentialsPost;

@end

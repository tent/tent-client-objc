//
//  Post.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TCPost.h"

@implementation TCPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"publishedAt": @"published_at",
             @"receivedAt": @"received_at",
             @"versionPublishedAt": @"version.published_at",
             @"versionReceivedAt": @"version.received_at",
             @"ID": @"id",
             @"typeURI": @"type",
             @"versionID": @"version.id",
             @"versionParents": @"version.parents",
             @"mentions": @"mentions",
             @"refs": @"refs",
             @"content": @"content",
             @"permissionsPublic": @"permissions.public",
             @"permissionsEntities": @"permissions.entities",
             @"permissionsGroups": @"permissions.groups"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([@[@"publishedAt", @"receivedAt", @"versionPublishedAt", @"versionReceivedAt"] containsObject:key]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *timestamp) {
            if (!timestamp) {
                return timestamp;
            }

            return [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000];
        } reverseBlock:^id(id date) {
            if (!date) {
                return date;
            }

            return [NSNumber numberWithDouble:[(NSDate *)date timeIntervalSince1970] * 10000];
        }];
    }

    return nil;
}

+ (NSValueTransformer *)permissionsPublicJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *wrappedBoolean) {
        return wrappedBoolean;
    } reverseBlock:^id(NSNumber *wrappedBoolean) {
        return wrappedBoolean.boolValue ? @YES : @NO;
    }];
}

- (id)init {
    self = [super init];
    if (self == nil) return nil;

    self.permissionsPublic = YES;

    return self;
}

@end

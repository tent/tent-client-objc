//
//  Post.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//

#import "TCPost.h"
#import "TCMetaPost.h"
#import "NSJSONSerialization+ObjectCleanup.h"

@implementation TCPost

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if ([[JSONDictionary objectForKey:@"type"] hasPrefix:@"https://tent.io/types/meta/"]) {
        return [TCMetaPost class];
    }

    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"publishedAt": @"published_at",
             @"receivedAt": @"received_at",
             @"versionPublishedAt": @"version.published_at",
             @"versionReceivedAt": @"version.received_at",
             @"ID": @"id",
             @"entityURI": @"entity",
             @"typeURI": @"type",
             @"versionID": @"version.id",
             @"versionParents": @"version.parents",
             @"mentions": @"mentions",
             @"refs": @"refs",
             @"content": @"content",
             @"permissionsPublic": @"permissions.public",
             @"permissionsEntities": @"permissions.entities",
             @"permissionsGroups": @"permissions.groups",
             @"attachments": @"attachments"
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

+ (NSValueTransformer *)entityURIJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *entityStr) {
        return [NSURL URLWithString:entityStr];
    } reverseBlock:^id(NSURL *entityURI) {
        return [entityURI absoluteString];
    }];
}

- (id)init {
    self = [super init];
    if (self == nil) return nil;

    self.permissionsPublic = YES;

    return self;
}

- (NSDictionary *)serializeJSONObject {
    return [NSJSONSerialization removeEmptyProperties:[MTLJSONAdapter JSONDictionaryFromModel:self]];
}

@end

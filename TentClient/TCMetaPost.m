//
//  TCMetaPost.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCMetaPost.h"
#import "TCMetaPostServer.h"
#import "NSArray+Filtering.h"

@implementation TCMetaPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary: @{
      @"content": NSNull.null,
      @"servers": @"content.servers",
      @"profileName": @"content.profile.name",
      @"profileBio": @"content.profile.bio",
      @"profileWebsite": @"content.profile.website",
      @"profileLocation": @"content.profile.location",
      @"metaEntityURI": @"content.entity",
      @"previousEntities": @"content.previous_entities"
    }];

    return [NSDictionary dictionaryWithDictionary:mapping];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([@[@"profileWebsite", @"metaEntityURI"] containsObject:key]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *urlStr) {
            if (!urlStr) {
                return NSNull.null;
            }

            return [NSURL URLWithString:urlStr];
        } reverseBlock:^id(NSURL *url) {
            if (!url) {
                return NSNull.null;
            }

            return [url absoluteString];
        }];
    }

    return [super JSONTransformerForKey:key];
}

+ (NSValueTransformer *)serversJSONTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:[TCMetaPostServer class]];
}

- (TCMetaPostServer *)preferredServer {
    return [self preferredServerFromIndex:[NSNumber numberWithInt:0]];
}

- (TCMetaPostServer *)preferredServerFromIndex:(NSNumber *)index {
    NSArray *sortedServers = [self.servers filteredArrayUsingKeepBlock:^BOOL(TCMetaPostServer *server) {
        return [server.preferenceIndex integerValue] >= [index integerValue] ? YES : NO;
    } valueBlock:^id(id obj) {
        return obj;
    }];

    return [sortedServers firstObject];
}

@end

//
//  TCMetaPost.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
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

+ (NSValueTransformer *)profileWebsiteJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *urlStr) {
        if (!urlStr) {
            return urlStr;
        }

        return [NSURL URLWithString:urlStr];
    } reverseBlock:^id(NSURL *url) {
        if (!url) {
            return url;
        }

        return [url absoluteString];
    }];
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

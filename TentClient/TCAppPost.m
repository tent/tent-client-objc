//
//  TCAppPost.m
//  TentClient
//
//  Created by Jesse Stuart on 9/28/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCAppPost.h"
#import "NSArray+Filtering.h"

@implementation TCAppPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary: @{
                                         @"content": NSNull.null,
                                         @"name": @"content.name",
                                         @"appDescription": @"content.description",
                                         @"URL": @"content.url",
                                         @"redirectURI": @"content.redirect_uri",
                                         @"notificationURL": @"content.notification_url",
                                         @"notificationTypes": @"content.notification_types",
                                         @"readTypes": @"content.types.read",
                                         @"writeTypes": @"content.types.write",
                                         @"scopes": @"content.scopes",
                                         @"credentials": NSNull.null
                                         }];
    
    return [NSDictionary dictionaryWithDictionary:mapping];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([@[@"URL", @"redirectURI", @"notificationURL"] containsObject:key]) {
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

@end

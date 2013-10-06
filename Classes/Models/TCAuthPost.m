//
//  TCAuthPost.m
//  TentClient
//
//  Created by Jesse Stuart on 9/28/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCAuthPost.h"

@implementation TCAuthPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary: @{
                                         @"readTypes": @"content.types.read",
                                         @"writeTypes": @"content.types.write",
                                         @"scopes": @"content.scopes",
                                         @"credentials": NSNull.null
                                         }];

    return [NSDictionary dictionaryWithDictionary:mapping];
}

@end

//
//  NSURL+Extentions.m
//  TentClient
//
//  Created by Jesse Stuart on 10/3/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "NSURL+Extentions.h"
#import "NSArray+Filtering.h"
#import "NSString+Parser.h"

@implementation NSURL (Extentions)

- (NSDictionary *)parseQueryString {
    NSMutableDictionary *extractedParams = [[NSMutableDictionary alloc] init];

    NSArray *queryComponents = [[self query] componentsSeparatedByString:@"&"];
    for (NSString *part in queryComponents) {
        NSArray *keyAndValue = [[part componentsSeparatedByString:@"="] transposedArrayUsingBlock:^id(NSString *keyOrValueStr) {
            return [keyOrValueStr stringByRemovingPercentEncoding];
        }];

        [extractedParams setValue:[keyAndValue objectAtIndex:1] forKey:[keyAndValue objectAtIndex:0]];
    }

    return [NSDictionary dictionaryWithDictionary:extractedParams];
}

- (NSString *)encodedPath {
    NSString *urlStr = [self absoluteString];
    NSString *host = [self host];

    NSNumber *hostIndex = [NSNumber numberWithUnsignedInteger:[urlStr firstIndexOf:host]];

    NSNumber *pathIndex = [NSNumber numberWithInteger:([hostIndex integerValue] + [host length])];

    return [urlStr substringFromIndex:[pathIndex integerValue]];
}

@end

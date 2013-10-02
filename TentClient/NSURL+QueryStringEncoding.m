//
//  NSURL+QueryStringEncoding.m
//  TentClient
//
//  Created by Jesse Stuart on 10/1/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "NSURL+QueryStringEncoding.h"
#import "NSArray+Filtering.h"

@implementation NSURL (QueryStringEncoding)

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

@end

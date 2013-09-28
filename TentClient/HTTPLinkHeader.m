//
//  HTTPLinkHeader.m
//  TentClient
//
//  Created by Jesse Stuart on 9/26/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//

#import "HTTPLinkHeader.h"

@implementation HTTPLinkHeader

+ (NSArray *)parseLinks:(NSString *)linkHeader {
    // TODO: parse links from header
    // </tent/posts/https%3A%2F%2Fjesse.cupcake.is/meta>; rel="https://tent.io/rels/meta-post"

    // parse out attributes [^=]+=['"][^'"]+['"]

    NSRegularExpression *linkPartRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=[<])[^>]+(?=[>])" options:NSRegularExpressionCaseInsensitive error:nil];

    NSRegularExpression *attributePartRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]+=['\"]+[^'\"]+['\"]" options:NSRegularExpressionCaseInsensitive error:nil];

    NSMutableArray *links = [[NSMutableArray alloc] init];

    for (NSString *linkStr in [linkHeader componentsSeparatedByString:@","]) {
        NSTextCheckingResult *match = [linkPartRegex firstMatchInString:linkStr options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [linkStr length])];

        if (!match) {
            continue;
        }

        HTTPLinkHeader *link = [[HTTPLinkHeader alloc] init];
        link.URL = [NSURL URLWithString:[linkStr substringWithRange:match.range]];

        NSMutableDictionary *linkAttrs = [[NSMutableDictionary alloc] init];

        [attributePartRegex enumerateMatchesInString:linkStr options:NSMatchingReportCompletion range:NSMakeRange(0, [linkStr length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result) {
                NSArray *attrKeyVal = [[linkStr substringWithRange:result.range] componentsSeparatedByString:@"="];
                NSString *value = [attrKeyVal objectAtIndex:1];
                value = [value substringWithRange:NSMakeRange(1, [value length] - 2)]; // remove "s
                [linkAttrs setObject:value forKey:[attrKeyVal objectAtIndex:0]];
            }
        }];

        link.attribtues = [NSDictionary dictionaryWithDictionary:linkAttrs];

        [links addObject:link];
    }

    return [NSArray arrayWithArray:links];
}

@end

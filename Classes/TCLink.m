//
//  TCLink.m
//  TentClient
//
//  Created by Jesse Stuart on 10/6/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCLink.h"

@implementation TCLink

+ (NSArray *)parseHTMLLinkTagsFromHTML:(NSString *)htmlString {
    NSRegularExpression *linkRegex = [NSRegularExpression regularExpressionWithPattern:@"<link[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];

    NSRegularExpression *attributePartRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]+=['\"]+[^'\"]+['\"]" options:NSRegularExpressionCaseInsensitive error:nil];

    NSMutableArray *linkStrings = [[NSMutableArray alloc] init];
    [linkRegex enumerateMatchesInString:htmlString options:NSMatchingReportCompletion range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            [linkStrings addObject:[htmlString substringWithRange:result.range]];
        }
    }];

    NSMutableArray *links = [[NSMutableArray alloc] init];

    for (NSString *linkStr in linkStrings) {
        TCLink *link = [[TCLink alloc] init];

        NSMutableDictionary *linkAttrs = [[NSMutableDictionary alloc] init];

        [attributePartRegex enumerateMatchesInString:linkStr options:NSMatchingReportCompletion range:NSMakeRange(0, [linkStr length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result) {
                NSArray *attrKeyVal = [[linkStr substringWithRange:result.range] componentsSeparatedByString:@"="];
                NSString *value = [attrKeyVal objectAtIndex:1];
                value = [value substringWithRange:NSMakeRange(1, [value length] - 2)]; // remove "s
                [linkAttrs setObject:value forKey:[attrKeyVal objectAtIndex:0]];
            }
        }];

        link.attributes = [NSDictionary dictionaryWithDictionary:linkAttrs];
        link.URL = [NSURL URLWithString:[link.attributes objectForKey:@"href"]];

        [links addObject:link];
    }
    
    return [NSArray arrayWithArray:links];
}

+ (NSArray *)parseHTTPLinkHeader:(NSString *)linkHeader {
    NSRegularExpression *linkPartRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=[<])[^>]+(?=[>])" options:NSRegularExpressionCaseInsensitive error:nil];

    NSRegularExpression *attributePartRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]+=['\"]+[^'\"]+['\"]" options:NSRegularExpressionCaseInsensitive error:nil];

    NSMutableArray *links = [[NSMutableArray alloc] init];

    for (NSString *linkStr in [linkHeader componentsSeparatedByString:@","]) {
        NSTextCheckingResult *match = [linkPartRegex firstMatchInString:linkStr options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, [linkStr length])];

        if (!match) {
            continue;
        }

        TCLink *link = [[TCLink alloc] init];
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

        link.attributes = [NSDictionary dictionaryWithDictionary:linkAttrs];

        [links addObject:link];
    }
    
    return [NSArray arrayWithArray:links];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ URL: %@ attributes: %@>", self.class, self.URL, self.attributes];
}

@end

//
//  HTMLLink.m
//  TentClient
//
//  Created by Jesse Stuart on 9/26/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "HTMLLink.h"

@implementation HTMLLink

+ (NSArray *)parseLinks:(NSString *)htmlString {
    NSRegularExpression *linkRegex = [NSRegularExpression regularExpressionWithPattern:@"<link[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];

    NSRegularExpression *attributePartRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]+=['\"]+[^'\"]+['\"]" options:NSRegularExpressionCaseInsensitive error:nil];

    NSMutableArray *linkStrings = [[NSMutableArray alloc] init];
    [linkRegex enumerateMatchesInString:htmlString options:NSMatchingCompleted range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            [linkStrings addObject:[htmlString substringWithRange:result.range]];
        }
    }];

    NSMutableArray *links = [[NSMutableArray alloc] init];

    for (NSString *linkStr in linkStrings) {
        HTMLLink *link = [[HTMLLink alloc] init];

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
        link.URL = [NSURL URLWithString:[link.attribtues objectForKey:@"href"]];

        [links addObject:link];
    }

    return [NSArray arrayWithArray:links];
}

@end

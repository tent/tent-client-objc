//
//  TCCredentialsPost.m
//  TentClient
//
//  Created by Jesse Stuart on 9/28/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TCCredentialsPost.h"

@implementation TCCredentialsPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary: @{
                                         @"key": @"content.hawk_key",
                                         @"algorithm": @"content.hawk_algorithm"
                                         }];

    return [NSDictionary dictionaryWithDictionary:mapping];
}

+ (NSValueTransformer *)algorithmURIJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *algorithm) {
        if ([algorithm isEqualToString:@"sha-256"]) {
            return [NSNumber numberWithInt:CryptoAlgorithmSHA256];
        }

        return [[NSNull alloc] init];
    } reverseBlock:^id(NSNumber *algorithm) {
        if ([algorithm integerValue] == CryptoAlgorithmSHA256) {
            return @"sha-256";
        }

        return [[NSNull alloc] init];
    }];
}

@end

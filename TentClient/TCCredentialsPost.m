//
//  TCCredentialsPost.m
//  TentClient
//
//  Created by Jesse Stuart on 9/28/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCCredentialsPost.h"

@implementation TCCredentialsPost

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];

    [mapping removeObjectForKey:@"content"];

    [mapping addEntriesFromDictionary: @{
                                         @"key": @"content.hawk_key",
                                         @"algorithm": @"content.hawk_algorithm"
                                         }];

    return [NSDictionary dictionaryWithDictionary:mapping];
}

+ (NSValueTransformer *)algorithmJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *algorithm) {
        // SHA256 is currently the only valid algorithm
        return [NSNumber numberWithInteger:CryptoAlgorithmSHA256];
    } reverseBlock:^id(NSNumber *algorithm) {
        // SHA256 is current the only valid algorithm
        return @"sha256";
    }];
}

@end

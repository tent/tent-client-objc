//
//  NSDictionary+Filtering.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//

#import "NSDictionary+Filtering.h"

@implementation NSDictionary (Filtering)

- (NSDictionary *)filterObjectsUsingKeepBlock:(BOOL (^)(id, id))keepBlock valueBlock:(id (^)(id, id))valueBlock {
    NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL shouldKeep = keepBlock(key, obj);

        if (shouldKeep) {
            [tmpDictionary setObject:valueBlock(key, obj) forKey:key];
        }
    }];

    return [NSDictionary dictionaryWithDictionary:tmpDictionary];
}

@end

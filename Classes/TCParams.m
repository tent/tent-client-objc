//
//  TCParams.m
//  TentClient
//
//  Created by Jesse Stuart on 10/6/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCParams.h"
#import "NSString+URLEncode.h"

@implementation TCParams

+ (instancetype)paramsWithDictionary:(NSDictionary *)dictionary {
    TCParams *params = [[TCParams alloc] init];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [params addValue:obj forKey:key];
    }];

    return params;
}

+ (instancetype)paramsFromURL:(NSURL *)URL {
    TCParams *params = [[TCParams alloc] init];

    [[[URL query] componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL *stop) {
        NSArray *keyAndValue = [param componentsSeparatedByString:@"="];

        if ([keyAndValue count] != 2) return;

        NSString *key = [[keyAndValue objectAtIndex:0] stringByRemovingPercentEncoding];
        NSString *value = [[[keyAndValue objectAtIndex:1] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByRemovingPercentEncoding];

        [params addValue:value forKey:key];
    }];

    return params;
}

- (instancetype)init {
    self = [super init];

    if (!self) return nil;

    self.keys = [[NSMutableArray alloc] init];

    self.values = [[NSMutableArray alloc] init];

    return self;
}

- (void)addValue:(id)value forKey:(NSString *)key {
    NSString *valueString;

    if ([value isKindOfClass:NSArray.class]) {
        valueString = [((NSArray *)value) componentsJoinedByString:@","];
    } else if ([value isKindOfClass:NSString.class]) {
        valueString = value;
    } else {
        NSLog(@"<%@ -addValue:forKey:> Invalid value: %@", self.class, value);
        return;
    }

    [self.keys addObject:key];
    [self.values addObject:valueString];
}

- (void)removeValuesForKey:(NSString *)key {
    NSIndexSet *indexes = [self.keys indexesOfObjectsPassingTest:^BOOL(NSString *obj, NSUInteger idx, BOOL *stop) {
        return [obj isEqualToString:key];
    }];

    [self.keys removeObjectsAtIndexes:indexes];
    [self.values removeObjectsAtIndexes:indexes];
}

- (NSString *)urlEncodeParams {
    NSMutableArray *components = [[NSMutableArray alloc] init];

    [self.keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *value = [self.values objectAtIndex:idx];
        [components addObject:[@[
                                 [key stringByAddingURLPercentEncoding],
                                 [value stringByAddingURLPercentEncoding]
                                 ] componentsJoinedByString:@"="]];
    }];

    return [components componentsJoinedByString:@"&"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ keys=%@ values=%@>", self.class, self.keys, self.values];
}

@end

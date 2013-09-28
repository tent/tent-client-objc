//
//  NSJSONSerialization+ObjectCleanup.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//

#import "NSJSONSerialization+ObjectCleanup.h"
#import "NSDictionary+Filtering.h"
#import "NSArray+Filtering.h"

@implementation NSJSONSerialization (ObjectCleanup)

+ (id)removeEmptyProperties:(id)JSONObject {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        // filter out null values / perform tail call recursion for each object
        return [(NSArray *)JSONObject filteredArrayUsingKeepBlock:^BOOL(id obj) {
            return ![obj isKindOfClass:[NSNull class]];
        } valueBlock:^id(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                return [self removeEmptyProperties:obj];
            }

            return obj;
        }];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)JSONObject filterObjectsUsingKeepBlock:^BOOL(id key, id obj) {
            return ![obj isKindOfClass:[NSNull class]];
        } valueBlock:^id(id key, id obj) {
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                return [self removeEmptyProperties:obj];
            }

            return obj;
        }];
    }

    return JSONObject;
}

@end

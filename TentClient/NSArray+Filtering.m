//
//  NSArray+Filtering.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "NSArray+Filtering.h"

@implementation NSArray (Filtering)

- (NSArray *)filteredArrayUsingKeepBlock:(BOOL (^)(id))keepBlock valueBlock:(id (^)(id))valueBlock {
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];

    for (id obj in self) {
        if (keepBlock(obj)) {
            [tmpArray addObject:valueBlock(obj)];
        }
    }

    return [NSArray arrayWithArray:tmpArray];
}

@end

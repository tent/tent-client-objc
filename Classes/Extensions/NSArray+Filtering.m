//
//  NSArray+Filtering.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import "NSArray+Filtering.h"

@implementation NSArray (Filtering)

- (NSArray *)filteredArrayUsingKeepBlock:(BOOL (^)(id))keepBlock
                              valueBlock:(id (^)(id))valueBlock {
  NSMutableArray *tmpArray = [[NSMutableArray alloc] init];

  for (id obj in self) {
    if (keepBlock(obj)) {
      [tmpArray addObject:valueBlock(obj)];
    }
  }

  return [NSArray arrayWithArray:tmpArray];
}

- (NSArray *)transposedArrayUsingBlock:(id (^)(id))block {
  NSMutableArray *tmpArray = [[NSMutableArray alloc] init];

  for (id obj in self) {
    [tmpArray addObject:block(obj)];
  }

  return [NSArray arrayWithArray:tmpArray];
}

@end

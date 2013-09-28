//
//  NSArray+Filtering.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import <Foundation/Foundation.h>

@interface NSArray (Filtering)

- (NSArray *)filteredArrayUsingKeepBlock:(BOOL (^)(id obj))keepBlock
                              valueBlock:(id (^)(id obj))valueBlock;

- (NSArray *)transposedArrayUsingBlock:(id (^)(id obj))block;

@end

//
//  TCParams.h
//  TentClient
//
//  Created by Jesse Stuart on 10/6/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import <Foundation/Foundation.h>

@interface TCParams : NSObject

@property (nonatomic) NSMutableArray *keys;
@property (nonatomic) NSMutableArray *values;

+ (instancetype)paramsWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)paramsFromURL:(NSURL *)URL;

- (void)addValue:(id)value forKey:(NSString *)key;

- (void)removeValuesForKey:(NSString *)key;

- (NSString *)urlEncodeParams;

@end

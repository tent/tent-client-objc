//
//  HTMLLink.h
//  TentClient
//
//  Created by Jesse Stuart on 9/26/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import <Foundation/Foundation.h>

@interface HTMLLink : NSObject

@property (nonatomic) NSURL *URL;

@property (nonatomic) NSDictionary *attribtues;

+ (NSArray *)parseLinks:(NSString *)htmlString;

@end

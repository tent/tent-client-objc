//
//  TCLink.h
//  TentClient
//
//  Created by Jesse Stuart on 10/6/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import <Foundation/Foundation.h>

@interface TCLink : NSObject

@property(nonatomic) NSURL *URL;

@property(nonatomic) NSDictionary *attributes;

+ (NSArray *)parseHTMLLinkTagsFromHTML:(NSString *)htmlString;

+ (NSArray *)parseHTTPLinkHeader:(NSString *)linkHeader;

@end

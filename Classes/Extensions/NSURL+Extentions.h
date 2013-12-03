//
//  NSURL+Extentions.h
//  TentClient
//
//  Created by Jesse Stuart on 10/3/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extentions)

- (NSDictionary *)parseQueryString;

- (NSString *)encodedPath;

@end

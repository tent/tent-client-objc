//
//  NSString+URLEncode.h
//  TentClient
//
//  Created by Jesse Stuart on 10/3/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

- (NSString *)stringByAddingURLPercentEncoding;

@end

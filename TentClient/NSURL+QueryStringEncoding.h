//
//  NSURL+QueryStringEncoding.h
//  TentClient
//
//  Created by Jesse Stuart on 10/1/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (QueryStringEncoding)

- (NSDictionary *)parseQueryString;

@end

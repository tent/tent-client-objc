//
//  HTMLLink.h
//  TentClient
//
//  Created by Jesse Stuart on 9/26/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLLink : NSObject

@property (nonatomic) NSURL *URL;

@property (nonatomic) NSDictionary *attribtues;

+ (NSArray *)parseLinks:(NSString *)htmlString;

@end

//
//  NSJSONSerialization+ObjectCleanup.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (ObjectCleanup)

+ (id)removeEmptyProperties:(id)JSONObject;

@end

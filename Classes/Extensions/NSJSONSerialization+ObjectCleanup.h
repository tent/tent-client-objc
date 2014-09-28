//
//  NSJSONSerialization+ObjectCleanup.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

@import Foundation;

@interface NSJSONSerialization (ObjectCleanup)

+ (id)removeEmptyProperties:(id)JSONObject;

@end

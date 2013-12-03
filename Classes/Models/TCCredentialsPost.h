//
//  TCCredentialsPost.h
//  TentClient
//
//  Created by Jesse Stuart on 9/28/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import "TCPost.h"
#import "CryptoProxy.h"

@interface TCCredentialsPost : TCPost

@property(nonatomic) NSString *key;
@property(nonatomic) CryptoAlgorithm algorithm;

@end

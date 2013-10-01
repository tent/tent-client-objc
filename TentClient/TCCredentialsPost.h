//
//  TCCredentialsPost.h
//  TentClient
//
//  Created by Jesse Stuart on 9/28/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TCPost.h"
#import "CryptoProxy.h"

@interface TCCredentialsPost : TCPost

@property (nonatomic) NSString *key;
@property (nonatomic) CryptoAlgorithm algorithm;

@end

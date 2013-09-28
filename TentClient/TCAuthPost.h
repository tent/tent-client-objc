//
//  TCAuthPost.h
//  TentClient
//
//  Created by Jesse Stuart on 9/28/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TCPost.h"

@interface TCAuthPost : TCPost

@property (nonatomic) NSArray *readTypes;
@property (nonatomic) NSArray *writeTypes;
@property (nonatomic) NSArray *scopes;

@property (nonatomic) NSDictionary *credentials;

@end

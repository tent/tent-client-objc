//
//  TCMetaPost.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TCPost.h"

@interface TCMetaPost : TCPost

@property (nonatomic) NSArray *servers;

@property (nonatomic) NSString *profileName;
@property (nonatomic) NSString *profileBio;
@property (nonatomic) NSURL *profileWebsite;
@property (nonatomic) NSString *profileLocation;

@end

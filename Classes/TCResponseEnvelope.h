//
//  TCResponseEnvelope.h
//  TentClient
//
//  Created by Jesse Stuart on 10/6/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "TCParams.h"

static NSString *const TCResponseEnvelopeErrorDomain =
    @"Response Envelope Error";

@interface TCResponseEnvelope : NSObject

@property(copy, nonatomic) NSDictionary *responseJSON;

@property(copy, nonatomic) NSURL *requestURL;

@property(nonatomic) NSError *error;

#pragma mark - initialization

+ (instancetype)responseEnvelopeWithJSONDictionary:(NSDictionary *)responseJSON
                                        requestURL:(NSURL *)requestURL;

- (instancetype)initWithResponseJSON:(NSDictionary *)responseJSON
                          requestURL:(NSURL *)requestURL;

#pragma mark - pagination

- (NSURL *)firstPageURL;

- (TCParams *)firstPageParams;

- (NSURL *)previousPageURL;

- (TCParams *)previousPageParams;

- (NSURL *)nextPageURL;

- (TCParams *)nextPageParams;

- (NSURL *)lastPageURL;

- (TCParams *)lastPageParams;

#pragma mark -

- (BOOL)isEmpty;

/* TODO:
    - post
    - mentions
    - versions
 */

- (NSArray *)posts;

- (NSArray *)refs;

- (NSDictionary *)profiles;

@end

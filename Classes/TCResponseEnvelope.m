//
//  TCResponseEnvelope.m
//  TentClient
//
//  Created by Jesse Stuart on 10/6/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import "TCResponseEnvelope.h"
#import "NSArray+Filtering.h"
#import "TCPost.h"

@implementation TCResponseEnvelope {
  NSDictionary *profiles;
  NSDictionary *pages;

  NSDictionary *post;

  NSArray *posts;
  NSArray *refs;
  NSArray *mentions;

  NSArray *deserializedPosts;
  NSArray *deserializedRefs;
}

+ (instancetype)responseEnvelopeWithJSONDictionary:(NSDictionary *)responseJSON
                                        requestURL:(NSURL *)requestURL {
  return [[TCResponseEnvelope alloc] initWithResponseJSON:responseJSON
                                               requestURL:requestURL];
}

- (instancetype)initWithResponseJSON:(NSDictionary *)responseJSON
                          requestURL:(NSURL *)requestURL {
  self = [super init];

  if (!self)
    return nil;

  self.responseJSON = responseJSON;

  self.requestURL = requestURL;

  if ([self.responseJSON objectForKey:@"error"]) {
    self.error = [NSError errorWithDomain:TCResponseEnvelopeErrorDomain
                                     code:1
                                 userInfo:self.responseJSON];
    return self;
  }

  profiles = [self.responseJSON objectForKey:@"profiles"];

  pages = [self.responseJSON objectForKey:@"pages"];

  post = [self.responseJSON objectForKey:@"post"];

  posts = [self.responseJSON objectForKey:@"posts"];

  refs = [self.responseJSON objectForKey:@"refs"];

  mentions = [self.responseJSON objectForKey:@"mentions"];

  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ responseJSON=%@>", self.class,
                                    [self.responseJSON description]];
}

#pragma mark - pagination

- (NSURL *)firstPageURL {
  if (pages && [pages objectForKey:@"first"]) {
    return [NSURL URLWithString:[pages objectForKey:@"first"]
                  relativeToURL:self.requestURL];
  } else {
    // TODO: Calculate first page URL
    return nil;
  }
}

- (TCParams *)firstPageParams {
  return [TCParams paramsFromURL:[self firstPageURL]];
}

- (NSURL *)previousPageURL {
  if (pages && [pages objectForKey:@"prev"]) {
    return [NSURL URLWithString:[pages objectForKey:@"prev"]
                  relativeToURL:self.requestURL];
  } else {
    // TODO: Calculate prev page URL
    return nil;
  }
}

- (TCParams *)previousPageParams {
  return [TCParams paramsFromURL:[self previousPageURL]];
}

- (NSURL *)nextPageURL {
  if (pages && [pages objectForKey:@"next"]) {
    return [NSURL URLWithString:[pages objectForKey:@"next"]
                  relativeToURL:self.requestURL];
  } else {
    // TODO: Calculate next page URL
    return nil;
  }
}

- (TCParams *)nextPageParams {
  return [TCParams paramsFromURL:[self nextPageURL]];
}

- (NSURL *)lastPageURL {
  if (pages && [pages objectForKey:@"last"]) {
    return [NSURL URLWithString:[pages objectForKey:@"last"]
                  relativeToURL:self.requestURL];
  } else {
    // TODO: Calculate last page URL
    return nil;
  }
}

- (TCParams *)lastPageParams {
  return [TCParams paramsFromURL:[self lastPageURL]];
}

#pragma mark -

- (BOOL)isEmpty {
  return [posts count] == 0;
}

- (NSArray *)posts {
  if (deserializedPosts)
    return deserializedPosts;

    deserializedPosts = [posts transposedArrayUsingBlock:^id(NSDictionary *postJSON) {
      NSError *error;

      TCPost *postModel = [MTLJSONAdapter modelOfClass:TCPost.class
                                    fromJSONDictionary:postJSON
                                                 error:&error];

      if (error) {
        NSLog(@"Error deserializing post: %@", error);
      }

      return postModel;
    }];

    return deserializedPosts;
}

- (NSArray *)refs {
  if (deserializedRefs)
    return deserializedRefs;

    deserializedRefs = [refs transposedArrayUsingBlock:^id(NSDictionary *postJSON) {
      NSError *error;

      TCPost *postModel = [MTLJSONAdapter modelOfClass:TCPost.class
                                    fromJSONDictionary:postJSON
                                                 error:&error];

      if (error) {
        NSLog(@"Error deserializing ref post: %@", error);
      }

      return postModel;
    }];

    return deserializedRefs;
}

- (NSDictionary *)profiles {
  return profiles;
}

@end

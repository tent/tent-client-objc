//
//  TCMetaPostServer.h
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

#import "Mantle.h"

@interface TCMetaPostServer : MTLModel<MTLJSONSerializing>

@property(nonatomic) NSString *urlTemplateOAuthAuth;
@property(nonatomic) NSString *urlTemplateOAuthToken;
@property(nonatomic) NSString *urlTemplateNewPost;
@property(nonatomic) NSString *urlTemplatePostAttachment;
@property(nonatomic) NSString *urlTemplateAttachment;
@property(nonatomic) NSString *urlTemplateBatch;
@property(nonatomic) NSString *urlTemplatePostsFeed;
@property(nonatomic) NSString *urlTemplatePost;
@property(nonatomic) NSString *urlTemplateServerInfo;
@property(nonatomic) NSString *urlTemplateDiscover;

@property(nonatomic) NSString *protocolVersion;

@property(nonatomic) NSNumber *preferenceIndex;

- (NSURL *)oauthAuthURL;
- (NSURL *)oauthAuthURLWithAppID:(NSString *)clientID;
- (NSURL *)oauthAuthURLWithAppID:(NSString *)clientID state:(NSString *)state;
- (NSURL *)oauthTokenURL;
- (NSURL *)newPostURL;
- (NSURL *)postAttachmentURLWithEntity:(NSString *)entity
                                postID:(NSString *)post
                        attachmentName:(NSString *)name;
- (NSURL *)attachmentURLWithEntity:(NSString *)entity
                  attachmentDigest:(NSString *)digest;
- (NSURL *)batchURL;
- (NSURL *)postsFeedURL;
- (NSURL *)postURLWithEntity:(NSString *)entity postID:(NSString *)post;
- (NSURL *)serverInfoURL;
- (NSURL *)discoveryURL;

@end

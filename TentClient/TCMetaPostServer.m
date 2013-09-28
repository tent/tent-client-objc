//
//  TCMetaPostServer.m
//  TentClient
//
//  Created by Jesse Stuart on 9/27/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCMetaPostServer.h"

@implementation TCMetaPostServer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"urlTemplateOAuthAuth": @"urls.oauth_auth",
             @"urlTemplateOAuthToken": @"urls.oauth_token",
             @"urlTemplateNewPost": @"urls.new_post",
             @"urlTemplatePostAttachment": @"urls.post_attachment",
             @"urlTemplateAttachment": @"urls.attachment",
             @"urlTemplateBatch": @"urls.batch",
             @"urlTemplatePostsFeed": @"urls.posts_feed",
             @"urlTemplatePost": @"urls.post",
             @"urlTemplateServerInfo": @"urls.server_info",
             @"urlTemplateDiscover": @"urls.discover"
           };
}

- (NSURL *)oauthAuthURL {
    return [NSURL URLWithString:self.urlTemplateOAuthAuth];
}

- (NSURL *)oauthTokenURL {
    return [NSURL URLWithString:self.urlTemplateOAuthToken];
}

- (NSURL *)newPostURL {
    return [NSURL URLWithString:self.urlTemplateNewPost];
}

- (NSURL *)postAttachmentURLWithEntity:(NSString *)entity postID:(NSString *)post attachmentName:(NSString *)name {
    return [NSURL URLWithString:[[[self.urlTemplatePostAttachment stringByReplacingOccurrencesOfString:@"{entity}" withString:entity]stringByReplacingOccurrencesOfString:@"{post}" withString:post] stringByReplacingOccurrencesOfString:@"{name}" withString:name]];
}

- (NSURL *)attachmentURLWithEntity:(NSString *)entity attachmentDigest:(NSString *)digest {
    return [NSURL URLWithString:[[self.urlTemplateAttachment stringByReplacingOccurrencesOfString:@"{entity}" withString:entity] stringByReplacingOccurrencesOfString:@"{digest}" withString:digest]];
}

- (NSURL *)batchURL {
    return [NSURL URLWithString:self.urlTemplateBatch];
}

- (NSURL *)postsFeedURL {
    return [NSURL URLWithString:self.urlTemplatePostsFeed];
}

- (NSURL *)postURLWithEntity:(NSString *)entity postID:(NSString *)post {
    return [NSURL URLWithString:self.urlTemplatePost];
}

- (NSURL *)serverInfoURL {
    return [NSURL URLWithString:self.urlTemplateServerInfo];
}

- (NSURL *)discoveryURL {
    return [NSURL URLWithString:self.urlTemplateDiscover];
}

@end

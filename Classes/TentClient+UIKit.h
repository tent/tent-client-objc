//
//  TentClient+UIKit.h
//  TentClient
//
//  Created by Jesse Stuart on 10/13/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TentClient.h"
#import <UIKit/UIKit.h>

@interface TentClient (UIKit)


/*
 - Registers app
 - Opens webview for user authentication
 - Performs token exchange when token returned
 - Calls success or failure block
 */
- (void)authenticateWithApp:(TCAppPost *)appPost
               successBlock:(void (^)(TCAppPost *appPost, TCCredentialsPost *authCredentialsPost))success
               failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
             viewController:(UIViewController *)controller;

@end

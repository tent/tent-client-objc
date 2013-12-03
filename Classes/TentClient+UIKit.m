//
//  TentClient+UIKit.m
//  TentClient
//
//  Created by Jesse Stuart on 10/13/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TentClient+UIKit.h"
#import "TCWebViewController.h"

@implementation TentClient (UIKit)

- (void)authenticateWithApp:(TCAppPost *)appPost
               successBlock:(void (^)(TCAppPost *, TCCredentialsPost *))success
               failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                      NSError *))failure
             viewController:(UIViewController *)controller {

    [self registerApp:appPost successBlock:^(TCAppPost *appPost, TCCredentialsPost *authCredentialsPost) {

      // Build OAuth redirect URI
      NSString *state =
          [self randomStringOfLength:[NSNumber numberWithInteger:32]];
      NSURL *oauthRedirectURI =
          [[self.metaPost preferredServer] oauthAuthURLWithAppID:appPost.ID
                                                           state:state];

      // Open oauthRedirectURI in a UIWebView
      TCWebViewController *webViewController = [TCWebViewController
          webViewControllerWithParentController:controller];

      [webViewController presentAnimated:YES
                              completion:^{
            [webViewController loadRequest:[NSURLRequest requestWithURL:oauthRedirectURI] withCompletionBlock:^(NSURLRequest *request) {
              if ([[request.URL absoluteString]
                      hasPrefix:[appPost.redirectURI absoluteString]]) {
                [webViewController dismissAnimated:YES
                                        completion:^{

                                          [self exchangeTokenForApp:appPost
                                                        callbackURI:request.URL
                                                              state:state
                                                       successBlock:success
                                                       failureBlock:failure];
                                        }];
              }
            }
                              abortBlock:^{
        failure(nil, [NSError errorWithDomain:TCOAuthUserAbortErrorDomain
                                         code:1
                                     userInfo:nil]);
            }];
                              }];
    }
failureBlock:failure];
}

@end

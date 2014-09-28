//
//  TCWebViewController.h
//  TentClient
//
//  Created by Jesse Stuart on 10/1/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found
// in the LICENSE file.
//

@import UIKit;

@interface TCWebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic) UIWebView *webView;
@property(nonatomic) UIViewController *parentController;

+ (instancetype)webViewControllerWithParentController:
        (UIViewController *)controller;

- (void)presentAnimated:(BOOL)flag completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion;

- (void)loadRequest:(NSURLRequest *)request
    withCompletionBlock:(void (^)(NSURLRequest *))completion
             abortBlock:(void (^)())abort;
@end

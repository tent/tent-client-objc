//
//  TCWebViewController.m
//  TentClient
//
//  Created by Jesse Stuart on 10/1/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "TCWebViewController.h"

@interface TCWebViewController ()

@end

@implementation TCWebViewController

{
    id completionBlock;
    NSURLRequest *currentRequest;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.view = self.webView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    currentRequest = request;

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    ((void (^)(NSURLRequest *))completionBlock)(webView.request);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    ((void (^)(NSURLRequest *))completionBlock)(currentRequest);
}

#pragma mark -

- (void)loadRequest:(NSURLRequest *)request withCompletionBlock:(void (^)(NSURLRequest *))completion {
    completionBlock = completion;

    [self.webView loadRequest:request];
}

@end

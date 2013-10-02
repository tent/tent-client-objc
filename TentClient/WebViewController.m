//
//  WebViewController.m
//  TentClient
//
//  Created by Jesse Stuart on 10/1/13.
//  Copyright (c) 2013 Tent.is, LLC. All rights reserved.
//  Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

{
    id completionBlock;
    NSURLRequest *currentRequest;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Dispose of any resources that can be recreated.
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

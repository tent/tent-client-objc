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
    id userAbortBlock;

    BOOL animated;

    NSURLRequest *currentRequest;

    UINavigationController *navigationController;
}

+ (instancetype)webViewControllerWithParentController:(UIViewController *)controller {
    TCWebViewController *webViewController = [[TCWebViewController alloc] init];

    webViewController.parentController = controller;

    return webViewController;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    navigationController = [[UINavigationController alloc] initWithRootViewController:self];

    [self setTitle:@"Authenticate"];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(userAbortButtonPressed:)];

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

- (void)presentAnimated:(BOOL)flag completion:(void (^)(void))completion {
    animated = flag;
    [self.parentController presentViewController:navigationController animated:flag completion:completion];
}

- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self.parentController dismissViewControllerAnimated:flag completion:completion];
}

- (void)loadRequest:(NSURLRequest *)request withCompletionBlock:(void (^)(NSURLRequest *))completion abortBlock:(void (^)())abort {
    completionBlock = completion;
    userAbortBlock = abort;

    [self.webView loadRequest:request];
}

- (void)userAbortButtonPressed:(id)sender {
    [self dismissAnimated:animated completion:^{
        ((void (^)())self->userAbortBlock)();
    }];
}

@end

//
//  WebViewController.m
//  TentClient
//
//  Created by Jesse Stuart on 10/1/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

{
    id completionBlock;
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    ((void (^)(NSURLRequest *))completionBlock)(webView.request);
}

#pragma mark -

- (void)loadRequest:(NSURLRequest *)request withCompletionBlock:(void (^)(NSURLRequest *))completion {
    completionBlock = completion;

    [self.webView loadRequest:request];
}

@end

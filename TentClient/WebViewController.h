//
//  WebViewController.h
//  TentClient
//
//  Created by Jesse Stuart on 10/1/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;

- (void)loadRequest:(NSURLRequest *)request withCompletionBlock:(void (^)(NSURLRequest *))completion;

@end

//
//  cngViewController.m
//  Vineyard Vines
//
//  Created by chris gann on 1/23/14.
//  Copyright (c) 2014 CN Gann Technology Group. All rights reserved.
//

#import "cngViewController.h"

@interface cngViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation cngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    [self loadRequestFromString:@"http://cnn.com"];
    _webView.delegate = (id)self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_webView.scrollView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}
-(void)handleRefresh:(UIRefreshControl *)refresh {
    NSString *fullURL = _webView.request.URL.absoluteString;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
    [refresh endRefreshing];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end

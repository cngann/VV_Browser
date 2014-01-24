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
    
    // Get URL From Settings Panel
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *udefURL = [defaults stringForKey:@"vv_url"];
    if (udefURL) {
        [self loadRequestFromString:udefURL];
    } else {
        [self loadRequestFromString:@"http://cngann.com"];
    }
    _webView.delegate = (id)self;
    
    // Add Reload Handler
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Reload Page"];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_webView.scrollView addSubview:refreshControl];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *infoMessage;
    infoMessage = [[UIAlertView alloc]
                   initWithTitle:@"Whoops!" message:@"There was a problem connecting to the Clienteling Application.  Please check your internet connection and try again."
                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    infoMessage.alertViewStyle = UIAlertViewStyleDefault;
    [infoMessage show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [self.webView loadRequest:urlRequest];
}

- (void)handleRefresh:(UIRefreshControl *)refresh {

    // Clear the Web Cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *fullURL = _webView.request.URL.absoluteString;
    NSURL *url = [NSURL URLWithString:fullURL];

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];

    [_webView loadRequest:requestObj];
    
    [refresh endRefreshing];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
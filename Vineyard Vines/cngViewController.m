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
        NSLog(@"Loading url: %@", udefURL );
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

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeRightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = (id)self;
    [_webView addGestureRecognizer:swipeRight];
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = (id)self;
    [_webView addGestureRecognizer:swipeLeft];
    
    UIScreenEdgePanGestureRecognizer *panRight = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panRightAction:)];
    [panRight setEdges:UIRectEdgeLeft];
    panRight.delegate = (id)self;
    [_webView addGestureRecognizer:panRight];
    
    // Cannot have more than one Pan direction recognizer in iOS 7.0.4
    // Known and Recognized bug
    
    /*
    UIScreenEdgePanGestureRecognizer *panLeft = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panLeftAction:)];
    [panLeft setEdges:UIRectEdgeRight];
    panLeft.delegate = (id)self;
    [_webView addGestureRecognizer:panLeft];
    */
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *infoMessage;
    infoMessage = [[UIAlertView alloc]
                   initWithTitle:@"Whoops!" message:@"There was a problem connecting to the Clienteling Application.  Please check your internet connection and try again."
                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    infoMessage.alertViewStyle = UIAlertViewStyleDefault;
    [infoMessage show];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    if ([requestString hasPrefix:@"ios-log:"]) {
        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
        NSLog(@"UIWebView console: %@", logString);
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *udefURL = [defaults stringForKey:@"vv_url"];
        NSRange range = [requestString rangeOfString:udefURL];
        if (range.length == 0) {
            [[UIApplication sharedApplication] openURL:[request URL]];
            return NO;
        }
    }
    return YES;
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
    [_webView reload];
    [refresh endRefreshing];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

// Swipe Right
- (void)swipeRightAction:(id)ignored
{
    // Call Browser's swipe functionality
    [_webView stringByEvaluatingJavaScriptFromString:@"swipe.run('right');"];
}

// Swipe Left
- (void)swipeLeftAction:(id)ignored
{
    // Call Browser's swipe functionality
    [_webView stringByEvaluatingJavaScriptFromString:@"swipe.run('left');"];
}

// Pan Right
- (void)panRightAction:(id)ignored
{
    // Call Browser's swipe far left functionality
    [_webView stringByEvaluatingJavaScriptFromString:@"swipe.run('panRight');"];
}

// Pan Left
/*
- (void)panLeftAction:(id)ignored
{
    // Call Browser's swipe far left functionality
    [_webView stringByEvaluatingJavaScriptFromString:@"swipe.run('panLeft');"];
}
*/

@end
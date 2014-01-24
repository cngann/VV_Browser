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
    [self loadRequestFromString:@"http://cngann.com"];
	// Do any additional setup after loading the view, typically from a nib.
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

@end

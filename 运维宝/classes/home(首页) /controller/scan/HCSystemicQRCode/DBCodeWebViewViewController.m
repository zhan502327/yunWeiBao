//
//  DBCodeWebViewViewController.m
//  运维宝
//
//  Created by zhang shuai on 2018/1/5.
//  Copyright © 2018年 com.stlm. All rights reserved.
//

#import "DBCodeWebViewViewController.h"

@interface DBCodeWebViewViewController ()<UIWebViewDelegate>

@end

@implementation DBCodeWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    
    
    NSURL *url = [NSURL URLWithString:self.filePath];
    //    创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    //    创建NSURLRequest
    [webView loadRequest:request];//加载
    //
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error----- %@",error);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    
}

@end

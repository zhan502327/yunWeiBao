//
//  YWWebViewController.m
//  运维宝
//
//  Created by zhandb on 2017/12/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWWebViewController.h"

@interface YWWebViewController ()<UIWebViewDelegate>



@end

@implementation YWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    [MBProgressHUD showMessage:@"正在打开文件" toView:self.view];

    
    NSURL *url = [NSURL URLWithString:self.filePath];
//    创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
//    创建NSURLRequest
    [webView loadRequest:request];//加载
//
 
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error----- %@",error);
    [MBProgressHUD hideHUDForView:self.view];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];

}



@end

//
//  YWWebViewController.m
//  运维宝
//
//  Created by zhandb on 2017/12/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWWebViewController.h"
#import <WebKit/WebKit.h>

@interface YWWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation YWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf", self.title];
    
    BOOL existed = [self pdfFileExist:fileName];
    
    if (existed == YES) {//存在。读取本地直接浏览
        
        [self readPDFwithfileName:fileName];
    }else{//开始下载
        
        [MBProgressHUD showMessage:@"正在加载文件" toView:self.view];

        [self downloadPDFWithUrl:self.filePath fileName:fileName];
        
    }
    
}



//判断pdf是否存在，如果不存在进行保存
- (BOOL)pdfFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}


//二：后台数据是PDF文件如何操作

//这个是下载后台返回的pdf文件进行下载
//首先是判断文件的存没有存在，然后进行数据的下载或者读取

//- (void)downloadPDFWithUrl:(NSString *)strurl fileName:(NSString *)fileName{
//
//    NSString *urlString = strurl;
//    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString * documentsDirectory = [paths lastObject];
//        NSString * path = [documentsDirectory stringByAppendingPathComponent:fileName];
//        //            path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//        return [NSURL fileURLWithPath:path];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//        if (error == nil) {
//            YWLog(@"下载成功");
//
//
//            NSArray *array = [self getAllFileNames:fileName];
//            for (int i = 0; i<array.count; i++) {
//                NSLog(@"%@", array[i]);
//            }
//
//            [self readPDFwithfileName:fileName];
//
//        }else{
//            YWLog(@"下载失败,请检查网络或者PDF文件过大");
//        }
//    }];
//    [task resume];
//
//}


#pragma mark -- 阅读本地PDF文件
- (void)readPDFwithfileName:(NSString *)fileName{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filePath = [paths objectAtIndex:0];
    
    NSString *path = [filePath stringByAppendingPathComponent:fileName];
    //    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists) {
        
        
        NSURL *urlttt = [NSURL fileURLWithPath:path];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:urlttt];
        
        [self.webView loadRequest:request];
        
        
    }
    
    
}






//下载PDF文件
- (void)downloadPDFWithUrl:(NSString *)url fileName:(NSString *)fileName{
    //设置下载文件保存的目录
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* _filePath = [paths objectAtIndex:0];

    //File Url
    NSString *fileUrl = url;

    //Encode Url 如果Url 中含有空格，一定要先 Encode
    fileUrl = [fileUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];

    NSString* filePath = [_filePath stringByAppendingPathComponent:fileName];

    //下载进行中的事件
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载的进度，如 0.53，就是 53%
        float progress =   (float)totalBytesRead / totalBytesExpectedToRead;
        YWLog(@"下载进度%.2f", progress);

        //下载完成
        //该方法会在下载完成后立即执行
        if (progress == 1.0) {

        }
    }];

    //下载完成的事件
    //该方法会在下载完成后 延迟 2秒左右执行
    //根据完成后需要处理的及时性不高，可以采用该方法
    [operation setCompletionBlock:^{
        YWLog(@"下载完成");

        NSArray *array = [self getAllFileNames:fileName];
        for (int i = 0; i<array.count; i++) {
            NSLog(@"%@", array[i]);
        }

        [self readPDFwithfileName:fileName];

    }];

    [operation start];

}



- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"----开始加载-----");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view];
    NSLog(@"----加载完成-----");
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"加载失败：error----- %@",error);
    [MBProgressHUD hideHUDForView:self.view];
    
    [MBProgressHUD showMessage:@"正在加载文件" toView:self.view];

    
    NSURL *url = [NSURL URLWithString:self.filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
    
    
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"error----- %@",error);
    [MBProgressHUD hideHUDForView:self.view];
}



- (WKWebView *)webView{
    if (_webView == nil) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];

    }
    return _webView;
}


//获取 NSDocumentDirectory 目录下的所有文件
- (NSArray *)getAllFileNames:(NSString *)dirName{
    // 获得此程序的沙盒路径
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 获取Documents路径
    // [patchs objectAtIndex:0]
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    //    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:dirName];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    return files;
}




@end

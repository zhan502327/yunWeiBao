//
//  YWDocInfoController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDocInfoController.h"
#import "YWDeviceDocCell.h"
#import "YWMyDevice.h"
#import "YWDeviceDocs.h"
#import "YWDocsGroup.h"
#import "ZYDownloadProgressView.h"
#import "HWProgressView.h"

@interface YWDocInfoController ()<UIDocumentInteractionControllerDelegate>
{
    //ZYDownloadProgressView *_progressView;
    CGFloat _progress;
}

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *assetInfos;
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *drawInfos;
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *docInfos;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/** NSTimer */
@property (nonatomic, strong) YWDocsGroup *docsGroup;
/**遮盖*/
@property (weak, nonatomic) UIView *cover;
/** 进度条 */
@property (nonatomic, weak) HWProgressView *progressView;

@end

@implementation YWDocInfoController

- (HWProgressView *)progressView
{
    if (!_progressView) {
        
        HWProgressView *progressView = [[HWProgressView alloc] initWithFrame:CGRectMake(30, 150, SCREEN_WIDTH-60, 18)];
        self.progressView  = progressView;
        [self.view addSubview:progressView];
    }
    return _progressView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 首先自动刷新一次
    [self autoRefresh];
    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
//创建刷新头部和尾部控件
- (void)setupFrenshHeaderandFooter
{
    // 默认当前页从1开始的
    self.currentPage = 1;
    // 设置header和footer
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.docInfos = [NSMutableArray array];
        [self getDeviceInfo];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getDeviceInfo];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getDeviceInfo
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_doucment.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    params[@"a_id"] = self.a_id;    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
         
        YWLog(@"getDeviceDoc--%@",responseObj);
        NSDictionary *deviceDocsDict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        
        if ([status isEqual:@1]) { // 数据已经加载完毕, 没有更多数据了
            YWDocsGroup *docGroup = [YWDocsGroup mj_objectWithKeyValues:deviceDocsDict];
            //取出模型
            
            [self.docInfos removeAllObjects];
            NSMutableArray *docsArr = [[NSMutableArray alloc] init];
            
            NSMutableArray *drawArr = [[NSMutableArray alloc] init];
            
            NSMutableArray *assetArr = [[NSMutableArray alloc] init];

            for (YWDeviceDocs *deviceDocs in docGroup.DocPublic) {
                [docsArr addObject:deviceDocs];
               
            }
            for (YWDeviceDocs *deviceDocs in docGroup.drawing) {
                
                [drawArr addObject:deviceDocs];
            }
            for (YWDeviceDocs *deviceDocs in docGroup.assets) {
                
                [assetArr addObject:deviceDocs];
                
            }
            
            //
            self.docInfos = docsArr;
            self.drawInfos = drawArr;
            self.assetInfos = assetArr;
            [self.tableView reloadData];
            /**停止刷新*/
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];

        }
        
        
    } failure:^(NSError *error) {
        /**停止刷新*/
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return self.drawInfos.count;
    } else if (section == 1){
        return self.docInfos.count;
    }else {
        return self.assetInfos.count;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //创建cell
    YWDeviceDocCell *cell = [YWDeviceDocCell cellWithTableView:tableView];
    
    if (indexPath.section == 0 && self.docInfos.count>0) {
        
        cell.deviceDoc = self.drawInfos[indexPath.row];;

    } else if (indexPath.section == 1){
        
        cell.deviceDoc = self.docInfos[indexPath.row];
    }else if (indexPath.section == 2 && self.docInfos.count>0){
        
        cell.deviceDoc = self.assetInfos[indexPath.row];;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = BGCLOLOR;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = FONT_14;
    if(section == 0) {
        titleLab.text = @"设备图纸";
    }else if (section == 1){
        titleLab.text = @"公共文档";
    }else if (section == 2){
        titleLab.text = @"设备文档";
    }
    [bgview addSubview:titleLab];
    return bgview;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && self.docInfos.count>0) {
        
        YWDeviceDocs *deviceModel = self.drawInfos[indexPath.row];;
        
    } else if (indexPath.section == 1){
        
        YWDeviceDocs *deviceModel = self.docInfos[indexPath.row];
    }else if (indexPath.section == 2 && self.docInfos.count>0){
        
        YWDeviceDocs *deviceModel = self.assetInfos[indexPath.row];;
    }

    
    
    
    [self tableViewClick];
    //添加定时器
    [self addTimer];
    
}


-(BOOL) isFileExist:(NSString *)docPath

{
    
    //获取Documents 下的文件路径
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *documentsDirectory = [paths lastObject];

    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:docPath];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:docPath]; //docPath为文件名

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL result = [fileManager fileExistsAtPath:filePath];
    
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    if (result) {
        //文件已经存在,直接打开
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否打开文件" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self openDocxWithPath:filePath];
        }]];
        
//        [alertController.actions setValue:[UIColor colorWithHexString:@"3998ef"] forKey:@"_titleTextColor"];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
        //文件不存在,要下载
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否下载并打开打开文件" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self downloadDocxWithDocPath:documentsDirectory fileName:docPath];
        }]];
        
//        [alertController.actions setValue:[UIColor colorWithHexString:@"3998ef"] forKey:@"_titleTextColor"];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

    return result;

}


/**
 下载文件
 
 @param docPath 文件路径
 @param fileName 文件名
 */
-(void)downloadDocxWithDocPath:(NSString *)docPath fileName:(NSString *)fileName {
    [MBProgressHUD showMessage:@"正在下载文件" toView:self.view];
    NSString *urlString = @"http://66.6.66.111:8888/UploadFile/";
    
    urlString = [urlString stringByAppendingString:fileName];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSProgress *progress;
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [docPath stringByAppendingPathComponent:fileName];
        NSLog(@"文件路径＝＝＝%@",path);
        return [NSURL fileURLWithPath:path];//这里返回的是文件下载到哪里的路径 要注意的是必须是携带协议file://
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"下载完成,正在打开" toView:self.view];
        //        if (error) {
        //
        //        }else {
        NSString *name = [filePath path];
        NSLog(@"下载完成文件路径＝＝＝%@",name);
        [self openDocxWithPath:name];//打开文件
        //        }
    }];
    [task resume];//开始下载 要不然不会进行下载的
    
}

/**
 打开文件
 
 @param filePath 文件路径
 */
-(void)openDocxWithPath:(NSString *)filePath {
    
    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    doc.delegate = self;
    [doc presentPreviewAnimated:YES];
}
#pragma mark - UIDocumentInteractionControllerDelegate
//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    
    return CGRectMake(0, 30, SCREEN_WIDTH , SCREEN_HEIGHT);
}
















/**
 *  弹出view
 */
- (void)tableViewClick
{
    
    CGFloat duration = 0.25;
    if (self.cover == nil) {
        // 1.添加遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = CGRectMake(15, 80, SCREEN_WIDTH-30, 120);
        //cover.frame = self.view.bounds;
        cover.backgroundColor = [UIColor lightGrayColor];
        cover.layer.cornerRadius = 5;
        cover.clipsToBounds = YES;
        cover.alpha = 0.9;
        [cover addTarget:self action:@selector(tableViewClick) forControlEvents:UIControlEventTouchUpInside];
        self.cover = cover;
        //[self.view addSubview:self.loginView];
        // 2.添加loginView到最中间
        [self.view bringSubviewToFront:self.tableView];
        [self.view insertSubview:cover belowSubview:self.tableView];
        
        [UIView animateWithDuration:duration animations:^{
            [self.view addSubview:self.progressView];
            
        }];
    } else {
        
        [self.cover removeFromSuperview];
        [self.progressView removeFromSuperview];
        self.cover = nil;
    }
    
}

#pragma mark ------------------ ZYDownloadProgress ---------------------
- (void)timerAction
{
    _progressView.progress += 0.01;
    
    if (_progressView.progress >= 1) {
        [self removeTimer];
        YWLog(@"完成");
    }
}

- (void)removeTimer
{
    [_timer invalidate];
    [self.progressView removeFromSuperview];
    [self.cover removeFromSuperview];

    _timer = nil;
}

- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

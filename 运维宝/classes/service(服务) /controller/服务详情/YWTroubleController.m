//
//  YWTroubleController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWTroubleController.h"
#import "YWMyDeviceCell.h"
#import "YXTextView.h"
#import "YWSercice.h"
#import "YWTrobleType.h"
#import "YWUser.h"

@interface YWTroubleController ()<UITableViewDelegate,UITableViewDataSource>

/**反馈已将输入框*/
@property (nonatomic, weak) YXTextView *supportTv;
/**提交按钮*/
@property (nonatomic, weak) UIButton *submitBtn;
/**提交按钮*/
@property (nonatomic, weak) UIButton *supportTypeBtn;
/**遮盖*/
@property (weak, nonatomic) UIView *cover;
/** 是否有人发布意见 */
@property (nonatomic, assign) BOOL  iderVCSendIderSuccess;
/** 用户模型 */
@property (nonatomic,strong) UITableView *tableView;
/** 用户模型 */
@property (nonatomic,strong) YWUser *user;

/** 用户模型 */
@property (nonatomic,strong) NSMutableArray *typeNums;
/** 用户模型 */
@property (nonatomic,copy) NSString *typeID;


@end

@implementation YWTroubleController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];

        _tableView.frame = CGRectMake((SCREEN_WIDTH-260)*0.5,(SCREEN_HEIGHT-500)*0.5,260,280);
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //创建子控件
    [self creatAllView];
    //通知您接收对象
    [YWNotificationCenter addObserver:self selector:@selector(userdetilInfo:) name:YWLoginSucesesNSNotification object:nil];
    
}

//通知
//用户模型数据
- (void)userdetilInfo:(NSNotification *)notifacation
{
    //取出用户模型
    YWUser *user = notifacation.userInfo[YWLogUser];
    self.user = user;
    
    //刷新页面
    
    
    YWLog(@"userdetilInfo--%@",user);
    //[self.tableView reloadData];
    
    
}

- (void)creatAllView
{
    
    //支持类型
    UILabel *supportLab = [[UILabel alloc] init];
    supportLab.textAlignment = NSTextAlignmentLeft;
    supportLab.numberOfLines = 0;
    supportLab.text = @"支持类型:";
    supportLab.textColor = [UIColor darkGrayColor];
    supportLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:supportLab];
    
    [supportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    //类型按钮
     
    UIButton *supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.supportTypeBtn = supportBtn;
    supportBtn.titleLabel.font = FONT_BOLD_16;
    supportBtn.layer.cornerRadius = 5;
    supportBtn.clipsToBounds = YES;
    supportBtn.layer.borderColor = LOGINCLOLOR.CGColor;
    supportBtn.layer.borderWidth = 0.5;
    supportBtn.titleLabel.font = FONT_15;
    [supportBtn setTitle:@"机械故障" forState:UIControlStateNormal];
    [supportBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [supportBtn addTarget:self action:@selector(supportBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:supportBtn];
    
    [supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(supportLab.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 30));

    }];

    
    //输入框
    
    YXTextView *supportTv = [[YXTextView alloc] init];
    self.supportTv = supportTv;
    supportTv.placeholder = @"请输入设备故障信息，专业工程师将会尽快给予解决和答复";
    
    supportTv.placeholderColor = [UIColor lightGrayColor];
    supportTv.layer.borderWidth = 0.5;
    supportTv.layer.borderColor = LOGINCLOLOR.CGColor;
    supportTv.font = FONT_15;
    [YWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:supportTv];
    
    [self.view addSubview:supportTv];
    [supportTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(supportLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 100));
    }];
    
    //提示标题
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"报修人:郑州运维。    电话:1888888888";
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(supportTv.mas_bottom);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];

    //选择按钮
    //邮箱输入
    UIButton *checkBtn = [[UIButton alloc] init];
    
    [checkBtn setImage:[UIImage imageNamed:@"checkbox_noselect"] forState:UIControlStateNormal];
    //选中状态
    [checkBtn setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];

    
    
    //提示扫描文字
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    
    tipLabel.text = @"出现在服务事件列表";
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkBtn.mas_right).offset(10);
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(3);
        make.height.mas_equalTo(20);
        
    }];
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn = submitBtn;
    submitBtn.titleLabel.font = FONT_BOLD_17;
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    submitBtn.backgroundColor = [UIColor lightGrayColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [submitBtn addTarget:self action:@selector(submitBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
}

/**
 *  监听文字改变
 */
- (void)textDidChange
{
    //如果输入框没有文字，提交按钮不能点击
    if (self.supportTv.text.length == 0) {
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        
    } else {
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = LOGINCLOLOR;
    }
    
}
//故障类型按钮点击事件
- (void)supportBtnDidClick:(UIButton *)button
{
    //故障类型按钮
    button.selected = !button.selected;
    
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/service_repair_type.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    if (self.a_id) {
        params[@"a_id"] = self.a_id;
    } else {
        params[@"a_id"] = self.deviceSercice.a_id;
    };
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        YWLog(@"getServiceSupport--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            self.typeNums = [YWTrobleType mj_objectArrayWithKeyValuesArray:dict];
            //获得模型数据
            //YWTrobleType *type = self.typeNums[0];
            //self.typeID = type.type_id;

            [self.tableView reloadData];
            /**停止刷新*/
            //[self.tableView.mj_header endRefreshing];
            //[self.tableView.mj_footer endRefreshing];
            
        }
        
    } failure:^(NSError *error) {
        /**停止刷新*/
        //[self.tableView.mj_header endRefreshing];
        //[self.tableView.mj_footer endRefreshing];
    }];

    //弹出中间view
    [self tableViewClick];
    
    YWLog(@"点击啦故障类型按钮");
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
        cover.frame = self.view.bounds;
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.5;
        [cover addTarget:self action:@selector(tableViewClick) forControlEvents:UIControlEventTouchUpInside];
        self.cover = cover;
        //[self.view addSubview:self.loginView];
        // 2.添加loginView到最中间
        [self.view bringSubviewToFront:self.tableView];
        [self.view insertSubview:cover belowSubview:self.tableView];
        
        [UIView animateWithDuration:duration animations:^{
            
            [self.view addSubview:self.tableView];
            
        }];
    } else {
        
        [self.cover removeFromSuperview];
        [self.tableView removeFromSuperview];
        self.cover = nil;
    }
    
}

//打对号按钮点击事件
- (void)checkBtnClick:(UIButton *)button
{
    //打对号按钮
    button.selected = !button.selected;
    
}
//提交按钮点击事件
- (void)submitBtnDidClick
{
   //判断是否输入内容
    if (self.supportTv.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入故障信息"];
    }
    
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/service_repair.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    //电站
    params[@"a_id"] = self.deviceSercice.a_id;
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //维修类型id
    if (self.typeID) {
         params[@"type_id"] = self.typeID;
    }
    //是否显示在提醒列表
    params[@"is_notice"] = self.deviceSercice.a_id;
    //用户名（Nick）
    params[@"user"] = kGetData(@"nick");
    //手机号
    params[@"mobile"] = kGetData(@"tel1");
    //内容
    params[@"content"] = self.supportTv.text;
    //（传固定字符串“01”）
    params[@"urgent"] = @"01";
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        YWLog(@"getServiceSupport--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            self.typeNums = [YWTrobleType mj_objectArrayWithKeyValuesArray:dict];
            [SVProgressHUD showInfoWithStatus:msg];
            //获得模型数据
            [self.tableView reloadData];
            /**停止刷新*/
            //[self.tableView.mj_header endRefreshing];
            //[self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showSuccessWithStatus:msg];
        }else{
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }

        
       

        
    } failure:^(NSError *error) {
        /**停止刷新*/
        //[self.tableView.mj_header endRefreshing];
        //[self.tableView.mj_footer endRefreshing];
    }];

}

#pragma mark--tableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.typeNums.count;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    static NSString *ID = @"trobleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    YWTrobleType *type = self.typeNums[indexPath.row];

    cell.textLabel.font = FONT_15;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = type.type_name;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取出当前行的模型
    YWTrobleType *type = self.typeNums[indexPath.row];
    //设置按钮的文字
    self.typeID = type.type_id;
    [self.supportTypeBtn setTitle:type.type_name forState:UIControlStateNormal];
    [self tableViewClick];
    
}

//移除通知
- (void)dealloc
{
    [YWNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////左侧分类
//- (void)setUpPopTableView
//{
//    self.tableView = ({
//        UITableView *tabView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        tabView.delegate = self;
//        tabView.dataSource = self;
//        tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tabView.backgroundColor = BGCLOLOR;
//        //tabView.hidden = YES;
//        tabView.showsVerticalScrollIndicator = NO;
//        _tableView = tabView;
//    });
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.view);
//        make.width.mas_equalTo(@150);
//        make.height.mas_equalTo(260);
//
//    }];
//}

@end

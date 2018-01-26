//
//  YWSerchViewController.h
//  运维宝
//
//  Created by 斌  on 2017/11/1.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWSerchViewController : UITableViewController

@property (nonatomic, copy) NSString *searchText;


/**
 判断是从哪个界面跳转进来的  首页 - 1     服务业 = 2
 */
@property (nonatomic, copy) NSString *type;

@end

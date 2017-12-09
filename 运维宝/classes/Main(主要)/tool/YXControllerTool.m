//
//  YXControllerTool.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/9.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YXControllerTool.h"
#import "YWTabbarController.h"
#import "HMNewfeatureViewController.h"

@implementation YXControllerTool

/**
 *  选择根控制器
 */
+ (void)chooseRootViewController
{
    
    
    //获取第一次使用版本号，比较上次使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    //从沙盒中取出上次存储的版本号
    kGetData(versionKey);
    
    //获取当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([currentVersion isEqualToString:kGetData(versionKey)]) {
        // 当前版本号 == 上次使用的版本：显示HMTabBarViewController
        [UIApplication sharedApplication].statusBarHidden = NO;
        window.rootViewController = [[YWTabbarController alloc] init];
        
    } else {// 当前版本号 != 上次使用的版本：显示版本新特性
        window.rootViewController = [[HMNewfeatureViewController alloc] init];
        
        // 存储这次使用的软件版本
        kDataPersistence(currentVersion,versionKey);
    }

}


@end

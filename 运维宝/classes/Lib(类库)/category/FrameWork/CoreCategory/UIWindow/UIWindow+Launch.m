//
//  LMNavController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//


#import "UIWindow+Launch.h"



@implementation UIWindow (Launch)


#pragma mark  主window
+(UIWindow *)appWindow{
    
    UIWindow *window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //状态栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //设置背景色
    window.backgroundColor=[UIColor whiteColor];
    
    //成为主窗口
    [window makeKeyAndVisible];
    
    //返回
    return window;
}



@end

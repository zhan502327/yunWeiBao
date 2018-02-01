//
//  YWTabbarController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWTabbarController.h"
#import "YWNavViewController.h"
#import "YWHomeViewController.h"
#import "YWCollectViewController.h"
#import "YWServiceViewController.h"
#import "YWEventViewController.h"
#import "YWProfileViewController.h"
#import "UITabBar+Badge.h"

@interface YWTabbarController ()

@end

@implementation YWTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.backgroundColor = [UIColor clearColor];
    
    //添加所有子控制器
    [self addAllChildVcs];
    
    //添加事件页的角标
    NSInteger firstEventCount = [kGetData(@"kNotificationOneIsLookedCount") integerValue];
    NSInteger secondEventCount = [kGetData(@"kNotificationTwoIsLookedCount") integerValue];
    NSInteger thirdEventCount = [kGetData(@"kNotificationThreeIsLookedCount") integerValue];

    NSInteger allCount = firstEventCount + secondEventCount + thirdEventCount;
    
    if (allCount > 0) {
        NSString *str = [NSString stringWithFormat:@"%ld",allCount];
        [self.tabBar showBadgeOnItemIndex:3 withTitleNum:str];

    }else{
        [self.tabBar hideBadgeOnItemIndex:3];
    }
}


/**
 *  添加所有的子控制器
 */
- (void)addAllChildVcs
{
    
    YWHomeViewController *home = [[YWHomeViewController alloc] init];//发现
    [self addOneChlildVc:home title:@"首页" imageName:@"icon_menu_home_normal" selectedImageName:@"icon_menu_home_press"];
    home.tabBarItem.title = @"首页";
    
    YWCollectViewController *shop = [[YWCollectViewController alloc] init];//发现
    [self addOneChlildVc:shop title:@"收藏" imageName:@"icon_menu_dynamic_normal" selectedImageName:@"icon_menu_dynamic_press"];
    YWServiceViewController *cooperate = [[YWServiceViewController alloc] init];//发现
    [self addOneChlildVc:cooperate title:@"服务" imageName:@"icon_menu_content_normal" selectedImageName:@"icon_menu_content_press"];
    YWEventViewController *event = [[YWEventViewController alloc] init];
    [self addOneChlildVc:event title:@"事件" imageName:@"WechatIMG5" selectedImageName:@"WechatIMG6"];
    
    YWProfileViewController *profile = [[YWProfileViewController alloc] init];//发现
    [self addOneChlildVc:profile title:@"我的" imageName:@"icon_menu_mymain_normal" selectedImageName:@"icon_menu_mymain_press"];
    
}

- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 声明这张图片用原图(别渲染)
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    YWNavViewController *nav = [[YWNavViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

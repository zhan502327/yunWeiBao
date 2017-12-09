//
//  XLSegmentSlideSwitch.h
//  实体联盟
//
//  Created by 贾斌 on 2017/7/7.
//  Copyright © 2017年 贾斌. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XLSlideSwitchDelegate.h"

@interface XLSegmentedSlideSwitch : UIView
/**
 * 需要显示的视图
 */
@property (nonatomic, strong) NSArray *viewControllers;
/**
 * 标题
 */
@property (nonatomic, strong) NSArray *titles;
/**
 * 选中位置
 */
@property (nonatomic, assign) NSInteger selectedIndex;
/**
 * Segmented高亮颜色
 */
@property (nonatomic, strong) UIColor *tintColor;
/**
 代理方法
 */
@property (nonatomic, weak) id <XLSlideSwitchDelegate>delegate;
/**
 * 初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers;
/**
 * 标题显示在ViewController中
 */
-(void)showInViewController:(UIViewController *)viewController;
/**
 * 标题显示在NavigationBar中
 */
-(void)showInNavigationController:(UINavigationController *)navigationController;
@end

//
//  UITabBar+Badge.h
//  运维宝
//
//  Created by zhang shuai on 2018/1/15.
//  Copyright © 2018年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index withTitleNum:(NSString *)count;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end

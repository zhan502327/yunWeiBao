//
//  UITabBar+Badge.m
//  运维宝
//
//  Created by zhang shuai on 2018/1/15.
//  Copyright © 2018年 com.stlm. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarItemNums 5.0    //tabbar的数量



@implementation UITabBar (Badge)


- (void)showBadgeOnItemIndex:(int)index withTitleNum:(NSString *)count{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.tag = 888 + index;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.layer.cornerRadius = 7.5;
    badgeLabel.text = count;
    badgeLabel.numberOfLines = 0;
    badgeLabel.font = [UIFont systemFontOfSize:10];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.backgroundColor = [UIColor redColor];
    [self addSubview:badgeLabel];
    
    CGRect tabFrame = self.frame;


    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    CGFloat width;
    if (count.length > 0) {
        width = 20;
    }else{
        width = 15;
    }
    badgeLabel.frame = CGRectMake(x, y, width, 15);
    
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end

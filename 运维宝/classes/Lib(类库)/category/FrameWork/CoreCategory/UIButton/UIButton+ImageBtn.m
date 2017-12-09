//
//  LMNavController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "UIButton+ImageBtn.h"
#import "UIImage+TintColor.h"

@implementation UIButton (ImageBtn)


/**
 *  快速生成一个含有图片的按钮：默认按钮在大小和图片一样大
 *
 *  @param imageName        图片名
 *  @param highlightedColor 按钮高亮的时候的颜色
 *
 *  @return 按钮
 */
+(UIButton *)buttonWithImageName:(NSString *)imageName highlightedColor:(UIColor *)highlightedColor{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *imageForNarmal=[UIImage imageNamed:imageName];
    UIImage *imageForhighlighted=[imageForNarmal tintColor:highlightedColor level:1.0f];
    
    //设置不同状态下的图片
    [btn setImage:imageForNarmal forState:UIControlStateNormal];
    [btn setImage:imageForhighlighted forState:UIControlStateHighlighted];
    
    btn.frame=(CGRect){CGPointZero,imageForNarmal.size};
    
    return btn;
}





@end

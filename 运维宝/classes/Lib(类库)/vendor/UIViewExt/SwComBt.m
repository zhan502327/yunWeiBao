
//
//  SwComBt.m
//  ShowApp
//
//  Created by 耿用强 on 15/8/28.
//  Copyright (c) 2015年 gyq. All rights reserved.
//

#import "SwComBt.h"

@implementation SwComBt
-(instancetype)init
{
    if (self = [super init]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = (contentRect.size.width-_imageSize.width)/2;
    CGFloat y = (contentRect.size.height-_imageSize.height)/2;
    CGFloat w = _imageSize.width;
    CGFloat h = _imageSize.height;
    //    return UIEdgeInsetsInsetRect(CGRectMake(x, y, w, h), UIEdgeInsetsMake(w * 0.1, w * 0.1, w * 0.1, w *0.1));
    return CGRectMake(x, y, w, h);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

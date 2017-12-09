//
//  SwComBt+Setup.m
//  ShowApp
//
//  Created by 耿用强 on 15/8/28.
//  Copyright (c) 2015年 gyq. All rights reserved.
//

#import "SwComBt+Setup.h"

@implementation SwComBt (Setup)
+ (SwComBt*)creatButton:(NSString*)name andTitleFont:(UIFont*)font andTitleColor:(UIColor*)color andImage:(UIImage*)image andImageSize:(CGSize)size andsel:(SEL)method andTaget:(id)obj
{
    SwComBt*button=[SwComBt buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font=font;
    [button setTitleColor:color forState:UIControlStateNormal];
    button.imageSize=size;
    [button addTarget:obj action:method forControlEvents:UIControlEventTouchUpInside];
    

    return button;
}
@end

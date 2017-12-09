//
//  SwComBt+Setup.h
//  ShowApp
//
//  Created by 耿用强 on 15/8/28.
//  Copyright (c) 2015年 gyq. All rights reserved.
//

#import "SwComBt.h"

@interface SwComBt (Setup)
+ (SwComBt*)creatButton:(NSString*)name andTitleFont:(UIFont*)font andTitleColor:(UIColor*)color andImage:(UIImage*)image andImageSize:(CGSize)size andsel:(SEL)method andTaget:(id)obj;
@end

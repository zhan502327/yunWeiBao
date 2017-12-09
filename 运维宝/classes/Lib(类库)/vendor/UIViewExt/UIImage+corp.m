//
//  UIImage+corp.m
//  ShowApp
//
//  Created by 耿用强 on 15/9/5.
//  Copyright (c) 2015年 gyq. All rights reserved.
//

#import "UIImage+corp.h"

@implementation UIImage (corp)

- (UIImage*)cropImageWithRect:(CGRect)cropRect {
    CGRect drawRect = CGRectMake(-cropRect.origin.x , -cropRect.origin.y, self.size.width * self.scale, self.size.height * self.scale);      UIGraphicsBeginImageContext(cropRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    [self drawInRect:drawRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();     UIGraphicsEndImageContext();
    return image;
}
@end

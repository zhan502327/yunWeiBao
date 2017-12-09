//
//  LMNavController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "UIImage+Blur.h"
#import "UIImage+Cut.h"
#import "UIImage+ImageEffects.h"

@implementation UIImage (Blur)

-(UIImage *)blurWithFuzzy:(CGFloat)fuzzy density:(CGFloat)density{
    
    //执行模糊
    UIImage *image=[self applyBlurWithRadius:fuzzy tintColor:nil saturationDeltaFactor:density maskImage:nil];
    
    //返回
    return image;
    
}


@end

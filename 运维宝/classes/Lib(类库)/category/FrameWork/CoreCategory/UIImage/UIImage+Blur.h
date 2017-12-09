//
//  LMNavController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)


/**
 *  产生一个模糊的图片:
 *
 *  fuzzy:                                  0~68.5f（范围）
 *
 *  density:                                0~5.0f （范围）
 */
-(UIImage *)blurWithFuzzy:(CGFloat)fuzzy density:(CGFloat)density;


@end

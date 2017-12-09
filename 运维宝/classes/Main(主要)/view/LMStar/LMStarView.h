//
//  LMStarView.h
//  联盟商城
//
//  Created by 贾斌 on 2017/7/29.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LMStarType) {
    
    ///整数
    LMKStarTypeInteger = 0,
    ///允许浮点(半颗星)
    LMKStarTypeFloat,

    
};

@interface LMStarView : UIView
/**
 *  回调
 */
@property(nonatomic,copy) void(^starBlock)(NSString *value);

/**星级0-5，默认5*/
@property (nonatomic,assign) CGFloat star;

/**是否允许改变星级  默认YES*/
@property (nonatomic,assign,getter=IsTouch) BOOL isTouch;

//是否允许改变星级
/**
 *  构建方法
 *  @param starSize 星星大小（默认为平分，间距是大小的一半）,默认填CGSizeZero
 *  @param style    类型（WTKStarTypeInteger-不允许半颗星）WTKStarTypeInteger下，star最低为1颗星
 */

- (instancetype)initWithFrama:(CGRect)frame starSize:(CGSize)starSize
                    withStyle:(LMStarType)style;

@end

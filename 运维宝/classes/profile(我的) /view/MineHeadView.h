//
//  MineHeadView.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@interface IconView : UIView
/** 头像 */
@property (nonatomic,weak) UIImageView *iconImageView;
/** 电话号 */
@property (nonatomic,weak) UILabel *phoneNum;

@end

@interface MineHeadView : UIImageView

/**分割线*/
@property (nonatomic,strong) UIView *lineView;

/** iconView */
@property (nonatomic,weak) IconView *iconView;
/** 设置按钮的点击回调 */
@property (nonatomic,strong) void (^loginButtonClickBlock)();
/** 便利构造方法 */
- (instancetype)initWithFrame:(CGRect)frame loginButtonClick:(void (^)())loginButtonClickBlock;
@end


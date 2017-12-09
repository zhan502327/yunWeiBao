//
//  HomeHedaerView.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWhederButton : UIButton
/** 头像 */
@property (nonatomic,weak) UIButton *statusBtn;
/** 状态label */
@property (nonatomic,weak) UILabel *statusLab;

@end



@interface HomeHedaerView : UIView


/** 头像 */
@property (nonatomic,weak) UIImageView *headerPicView;

/** iconView */
@property (nonatomic,weak) YWhederButton *hederButton;

@end

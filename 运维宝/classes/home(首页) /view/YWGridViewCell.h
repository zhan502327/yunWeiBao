//
//  YWGridViewCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWDeviceStatusNum;

@interface YWGridViewCell : UICollectionViewCell

/**类别按钮*/
@property (nonatomic, strong) UIButton *statusBtn;
/**类别名*/
@property (nonatomic, weak) UILabel *statusLabel;
/**模型*/
@property (nonatomic, strong) YWDeviceStatusNum *StatusNum;


@end

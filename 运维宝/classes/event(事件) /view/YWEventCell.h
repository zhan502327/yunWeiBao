//
//  YWEventCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWEventModel;

@interface YWEventCell : UITableViewCell

/** 颜色块 */
@property (nonatomic,weak) UIImageView *iconView;
/** 设备名 */
@property (nonatomic,weak) UILabel *titleLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *detilLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *dateLab;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;
//小红点
@property (nonatomic, weak) UIView *redView;


/**订单列表模型*/
@property (nonatomic, strong) YWEventModel *eventModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

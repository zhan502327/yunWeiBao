//
//  YWMaintenancelLogCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMaintenanceLog;

@interface YWMaintenancelLogCell : UITableViewCell

/** 设备详情 */
@property (nonatomic,weak) UILabel *detilLab;
/** 颜色块 */
@property (nonatomic,weak) UIButton *statusBtn;
/** 设备名 */
@property (nonatomic,weak) UILabel *titleLab;
/** 设备名 */
@property (nonatomic,weak) UILabel *nameLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *dateLab;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;


/**订单列表模型*/
@property (nonatomic, strong) YWMaintenanceLog *maintenanceLog;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

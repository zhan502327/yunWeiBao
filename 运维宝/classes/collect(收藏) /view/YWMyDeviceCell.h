//
//  YWMyDeviceCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWMyDevice;

@interface YWMyDeviceCell : UITableViewCell


/** 颜色块 */
@property (nonatomic,weak) UIImageView *colorView;
/** 设备名 */
@property (nonatomic,weak) UILabel *nameLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *detilLab;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;
/**订单列表模型*/
@property (nonatomic, strong) YWMyDevice *myDevice;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

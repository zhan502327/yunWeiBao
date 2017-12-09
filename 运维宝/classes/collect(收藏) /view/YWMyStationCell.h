//
//  YWMyStationCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMyStations;

@interface YWMyStationCell : UITableViewCell

/** 颜色块 */
@property (nonatomic,weak) UIImageView *colorView;
/** 设备名 */
@property (nonatomic,weak) UILabel *nameLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *detilLab;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;


/**收藏电站模型*/
@property (nonatomic, strong) YWMyStations *stations;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

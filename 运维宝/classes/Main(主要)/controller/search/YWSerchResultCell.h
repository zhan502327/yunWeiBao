//
//  YWSerchResultCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/12.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWSerch;

@interface YWSerchResultCell : UITableViewCell



/** 颜色块 */
@property (nonatomic,weak) UIImageView *colorView;
/** 设备名 */
@property (nonatomic,weak) UILabel *nameLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *detilLab;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;

/**收藏电站模型*/
@property (nonatomic, strong) YWSerch *serch;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

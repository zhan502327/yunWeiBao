//
//  YWCurrentStationCell.h
//  运维宝
//
//  Created by jiabin on 2017/11/13.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCurrentStationCell : UITableViewCell

/** 颜色块 */
@property (nonatomic,weak) UIButton *stationBtn;
/* 商品标题 */
@property (strong , nonatomic) UILabel *nameLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

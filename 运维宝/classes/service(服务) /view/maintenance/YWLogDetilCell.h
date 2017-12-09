//
//  YWLogDetilCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/5.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXTextView;

@interface YWLogDetilCell : UITableViewCell

/** 设备详情 */
@property (nonatomic,weak) UILabel *typeLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *dateLab;
/** 设备名 */
@property (nonatomic,weak) UILabel *desLab;
/** 设备名 */
@property (nonatomic,weak) UILabel *nameLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *phoneLab;
/**<#定时器#>*/
@property (nonatomic, strong) YXTextView *logDetilTv;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

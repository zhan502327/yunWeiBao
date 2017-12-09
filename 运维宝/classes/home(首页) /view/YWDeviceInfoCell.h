//
//  YWDeviceInfoCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/23.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWDeviceInfo;

@interface YWDeviceInfoCell : UITableViewCell

/**1类别按钮*/
@property (nonatomic, weak) UILabel *titleLab;
/**2类别按钮*/
@property (nonatomic, weak) UILabel *detilLab;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;
/**设备信息*/
@property (nonatomic, strong) YWDeviceInfo *deviceInfo;

/**电话*/
@property (copy, nonatomic) void (^didNamePhoneLab)(UILabel *label);


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

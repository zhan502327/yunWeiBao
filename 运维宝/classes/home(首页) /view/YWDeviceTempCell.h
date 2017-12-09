//
//  YWDeviceTempCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWDeviceTempInfo;

@interface YWDeviceTempCell : UITableViewCell


/**类别按钮*/
@property (nonatomic, weak) UIButton *statusBtn;

/**1类别按钮*/
@property (nonatomic, weak) UILabel *statusLab1;
/**2类别按钮*/
@property (nonatomic, weak) UILabel *statusLab2;
/**3类别按钮*/
@property (nonatomic, weak) UILabel *statusLab3;
/**订单列表模型*/
@property (nonatomic, strong) YWDeviceTempInfo *tempInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

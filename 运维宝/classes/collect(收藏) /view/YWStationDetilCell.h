//
//  YWStationDetilCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/21.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWDeviceDetil;

@interface YWStationDetilCell : UITableViewCell

/**1类别按钮*/
@property (nonatomic, weak) UIButton *statusBtn1;
/**2类别按钮*/
@property (nonatomic, weak) UIButton *statusBtn2;
/**3类别按钮*/
@property (nonatomic, weak) UIButton *statusBtn3;
/**4类别按钮*/
@property (nonatomic, weak) UIButton *statusBtn4;
/**类别名*/
@property (nonatomic, weak) UILabel *categoryLab;
/**设备按钮点击*/
@property (copy, nonatomic) void (^deviceBtnDidClick)(NSInteger *status);

/**订单列表模型*/
@property (nonatomic, strong) YWDeviceDetil *deviceDetil;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

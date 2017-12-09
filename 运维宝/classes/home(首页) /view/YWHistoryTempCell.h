//
//  YWHistoryTempCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWDeviceTempInfo;


@interface YWHistoryTempCell : UITableViewCell


/**类别按钮*/
@property (nonatomic, weak) UIButton *statusBtn;

/**1类别按钮*/
@property (nonatomic, weak) UIButton *tempBtn1;
/**2类别按钮*/
@property (nonatomic, weak) UIButton *tempBtn2;
/**3类别按钮*/
@property (nonatomic, weak) UIButton *tempBtn3;

/**tempBtna*/
@property (copy, nonatomic) void (^didTapABtn)(UIButton *abtn);
/**tempBtnb*/
@property (copy, nonatomic) void (^didTapBBtn)(UIButton *bbtn);
/**tempBtnc*/
@property (copy, nonatomic) void (^didTapCBtn)(UIButton *cbtn);

/**订单列表模型*/
@property (nonatomic, strong) YWDeviceTempInfo *tempInfo;

/**订单列表模型*/
//@property (nonatomic, strong) YWMyDevice *myDevice;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

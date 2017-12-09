//
//  YXButtonViewCell.h
//  运维宝
//
//  Created by jiabin on 2017/11/16.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXButtonViewCell : UITableViewCell

/**时间按钮*/
@property (nonatomic, strong) UIButton *titleBtn;
/**扫一扫*/
@property (copy, nonatomic) void (^didTapTimeBtn)(UIButton *timeBtn);

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

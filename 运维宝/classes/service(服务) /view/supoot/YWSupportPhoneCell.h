//
//  YWSupportPhoneCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWSupportPhoneCell : UITableViewCell



/**类别名*/
@property (nonatomic, weak) UILabel *namePhone;

/**类别名*/
@property (nonatomic, weak) UILabel *supportLab;

/**电话*/
@property (copy, nonatomic) void (^didNamePhoneLab)(UILabel *label);

/**订单列表模型*/
//@property (nonatomic, strong) LMOrderList *orderList;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

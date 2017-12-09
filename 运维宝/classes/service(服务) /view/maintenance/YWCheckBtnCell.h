//
//  YWCheckBtnCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/5.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCheckBtnCell : UITableViewCell

/** 颜色块 */
@property (nonatomic,weak) UIButton *checkBtn;
/* 商品标题 */
@property (strong , nonatomic) UILabel *goodsLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

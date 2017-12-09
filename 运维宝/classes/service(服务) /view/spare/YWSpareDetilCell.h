//
//  YWSpareDetilCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWSpareMange;

@interface YWSpareDetilCell : UITableViewCell

/**1类别按钮*/
@property (nonatomic, weak) UILabel *spareLab1;
/**2类别按钮*/
@property (nonatomic, weak) UILabel *spareLab2;
/**3类别按钮*/
@property (nonatomic, weak) UILabel *spareLab3;
/**4类别按钮*/
@property (nonatomic, weak) UILabel *spareLab4;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;

/**备件管理模型*/
@property (nonatomic, strong) YWSpareMange *spareMange;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

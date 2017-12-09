//
//  YWSationHeadCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/21.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWDeviceDetilInfo,YWSationHeadCell;

@protocol YWSationHeadCellDelegate<NSObject>
/**
 * 返回Y轴坐标数值的字符串
 */
- (void)collectionBtnClick:(YWSationHeadCell *)sationHeadCell;

@end
@interface YWSationHeadCell : UITableViewCell
/** 颜色块 */
@property (nonatomic,weak) UIImageView *colorView;
/** 设备名 */
@property (nonatomic,weak) UILabel *titleLab;
/** 收藏标记 */
@property (nonatomic,weak) UIButton *collectView;
/** 温度按钮 */
@property (nonatomic,weak) UIButton *tempBtn;
/** 水温按钮 */
@property (nonatomic,weak) UIButton *waterBtn;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;

/** 设备名 */
@property (nonatomic,weak) id<YWSationHeadCellDelegate> delegate;
/**订单列表模型*/
@property (nonatomic, strong) YWDeviceDetilInfo *detilInfo;

/**收藏按钮点击*/
@property (copy, nonatomic) void (^collectBtnDidClick)();
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

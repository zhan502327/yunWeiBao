//
//  YWSerchViewCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCSearchBar;
@interface YWSerchViewCell : UITableViewCell

/**搜索条*/
 @property (nonatomic, strong)  SCSearchBar *searchBar;

/** 颜色块 */
@property (nonatomic,weak) UIImageView *scanView;
/** 设备名 */
@property (nonatomic,weak) UILabel *serchLab;
/** 设备详情 */
@property (nonatomic,weak) UILabel *detilLab;
/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;
/**扫一扫*/
@property (copy, nonatomic) void (^didTapScanView)();

/**订单列表模型*/
//@property (nonatomic, strong) LMOrderList *orderList;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

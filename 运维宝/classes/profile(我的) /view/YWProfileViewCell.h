//
//  YWProfileViewCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWProfileViewCell : UITableViewCell

/**标题*/
@property (nonatomic, weak) UILabel *titleLabel;
/**描述*/
@property (nonatomic, weak) UILabel *detilLabel;
/* 商品图片 */
@property (strong , nonatomic) UIImageView *arrowImage;
/**分割线*/
@property (nonatomic,strong) UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

//
//  YXTextfiledCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/12.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTextfiledCell : UITableViewCell

/**输入框*/
@property (nonatomic, strong) UITextField *textfield;

/* 商品标题 */
@property (strong , nonatomic) UILabel *goodsLabel;

/**地址模型*/
//@property (nonatomic, strong) LMAddressModel *addressModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end

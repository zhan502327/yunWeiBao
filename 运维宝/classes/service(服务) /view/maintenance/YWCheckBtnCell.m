//
//  YWCheckBtnCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/5.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWCheckBtnCell.h"

@implementation YWCheckBtnCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"checkBtnCell";
    
    YWCheckBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWCheckBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    
    
    UIButton *checkBtn = [[UIButton alloc] init];
    self.checkBtn = checkBtn;
    [checkBtn setImage:[UIImage imageNamed:@"checkbox_noselect"] forState:UIControlStateNormal];
    //[checkBtn setTitle:@"已完成" forState:UIControlStateNormal];
    checkBtn.titleLabel.text = @"已完成";
    //选中状态
    [checkBtn setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkBtn];
    
    UILabel *goods = [[UILabel alloc] init];
    self.goodsLabel = goods;
    goods.font = FONT_14;
    goods.numberOfLines = 0;
    goods.textAlignment = NSTextAlignmentLeft;
    [goods sizeToFit];
    [self.contentView addSubview:goods];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(16);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkBtn.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(65, 25));
        make.centerY.mas_equalTo(self);
    }];

}
//打对号按钮点击事件
- (void)checkBtnClick:(UIButton *)button
{
    //打对号按钮
    button.selected = !button.selected;
    
}

    
@end

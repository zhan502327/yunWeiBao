//
//  YXTextfiledCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/12.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YXTextfiledCell.h"

@implementation YXTextfiledCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"textfiledCell";
    YXTextfiledCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YXTextfiledCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

//构造方法，添加需要的子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setSubViews
{
    
    UILabel *goods = [[UILabel alloc] init];
    self.goodsLabel = goods;
    goods.font = FONT_14;
    goods.numberOfLines = 0;
    goods.textAlignment = NSTextAlignmentLeft;
    [goods sizeToFit];
    [self.contentView addSubview:goods];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_Line;
    [self.contentView addSubview:line];
    
    //输入框
    UITextField *textfield = [[UITextField alloc] init];
    //textfield.backgroundColor = [UIColor orangeColor];
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.textfield.placeholder = @"hhh";
    self.textfield.font = FONT_13;
    self.textfield = textfield;
    [self.contentView addSubview:textfield];
    
    [self.goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:YWMargin];
        make.size.mas_equalTo(CGSizeMake(65, 25));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.goodsLabel.mas_right).offset(5);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,0.5));
    }];
}

@end

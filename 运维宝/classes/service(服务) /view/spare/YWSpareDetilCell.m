//
//  YWSpareDetilCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSpareDetilCell.h"
#import "YWSpareMange.h"

@implementation YWSpareDetilCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"spareDetilCell";
    
    YWSpareDetilCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWSpareDetilCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    //设备名称
    UILabel *spareLab1 = [[UILabel alloc] init];
    self.spareLab1 = spareLab1;
    spareLab1.font = FONT_14;
    spareLab1.text = @"郑州供电公司检修基地";
    spareLab1.textAlignment = NSTextAlignmentCenter;
    //spareLab1.backgroundColor = YWRandomColor;
    [self.contentView addSubview:spareLab1];
    
    UILabel *spareLab2 = [[UILabel alloc] init];
    self.spareLab2 = spareLab2;
    spareLab2.font = FONT_15;
    spareLab2.text = @"9";
    spareLab2.textAlignment = NSTextAlignmentCenter;
    //spareLab2.backgroundColor = YWRandomColor;
    [self.contentView addSubview:spareLab2];
    
    UILabel *spareLab3 = [[UILabel alloc] init];
    self.spareLab3 = spareLab3;
    spareLab3.font = FONT_15;
    spareLab3.text = @"RCS-1000";
    spareLab3.textAlignment = NSTextAlignmentCenter;
    //spareLab3.backgroundColor = YWRandomColor;
    [self.contentView addSubview:spareLab3];
    
    UILabel *spareLab4 = [[UILabel alloc] init];
    self.spareLab4 = spareLab4;
    spareLab4.font = FONT_15;
    spareLab4.text = @"RCS保护卡";
    spareLab4.textColor = LOGINCLOLOR;
    spareLab4.textAlignment = NSTextAlignmentLeft;
    //spareLab4.backgroundColor = YWRandomColor;
    [self.contentView addSubview:spareLab4];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    self.lineView.backgroundColor = COLOR_Line;
    self.lineView.alpha = 0.5;
    [self.contentView addSubview:self.lineView];
    
    
    [self.spareLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.38, 40));
    }];
    
    [self.spareLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.spareLab1.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.12, 40));
        
    }];
    [self.spareLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.spareLab2.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.23, 40));
        
    }];
    
    [self.spareLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self.spareLab3.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.28, 40));
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];

    
}

- (void)setSpareMange:(YWSpareMange *)spareMange
{
    
    _spareMange = spareMange;
    
    //库存地址
    self.spareLab1.text = spareMange.stock_location;
    
    //库存数
    self.spareLab2.text = spareMange.stock_num;
    
    // 备件型号
    self.spareLab3.text = spareMange.parts_model;
    
    // 备件名称
    self.spareLab4.text = spareMange.parts_name;
    
}


@end

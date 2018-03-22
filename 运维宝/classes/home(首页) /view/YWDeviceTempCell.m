//
//  YWDeviceTempCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceTempCell.h"
#import "YWDeviceTempInfo.h"

@implementation YWDeviceTempCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"deviceTempCell";
    
    YWDeviceTempCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWDeviceTempCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor  = [UIColor clearColor];
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
    
    //状态按钮1
    UIButton *statusBtn = [[UIButton alloc] init];
    self.statusBtn = statusBtn;
    statusBtn.userInteractionEnabled = NO;
    //statusBtn.backgroundColor = REDCLOLOR;
    statusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    statusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [statusBtn setTitle:@"上触指" forState:UIControlStateNormal];
    [statusBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [statusBtn setImage:[UIImage imageNamed:@"shippingAddressEdit"] forState:UIControlStateNormal];
    [self.contentView addSubview:statusBtn];
    //设备名称
    UILabel *statusLab1 = [[UILabel alloc] init];
    self.statusLab1 = statusLab1;
    statusLab1.font = FONT_15;
    statusLab1.text = @"C相";
    statusLab1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:statusLab1];
    
    UILabel *statusLab2 = [[UILabel alloc] init];
    self.statusLab2 = statusLab2;
    statusLab2.font = FONT_15;
    statusLab2.text = @"B相";
    statusLab2.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:statusLab2];
    
    UILabel *statusLab3 = [[UILabel alloc] init];
    self.statusLab3 = statusLab3;
    statusLab3.font = FONT_15;
    statusLab3.text = @"A相";
    statusLab3.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:statusLab3];
    
    //设置frame
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        
    }];
    
    [self.statusLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(65, 30));
    }];
    
    [self.statusLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.statusLab1.mas_left);
        make.size.mas_equalTo(CGSizeMake(65, 30));
        
    }];
    
    [self.statusLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.statusLab2.mas_left);
        make.size.mas_equalTo(CGSizeMake(65, 30));
        
    }];
    
}

- (void)setTempInfo:(YWDeviceTempInfo *)tempInfo
{
    _tempInfo = tempInfo;
    self.statusLab1.text = [NSString stringWithFormat:@"%@℃",tempInfo.c];
    self.statusLab2.text = [NSString stringWithFormat:@"%@℃",tempInfo.b];
    self.statusLab3.text = [NSString stringWithFormat:@"%@℃",tempInfo.a];
}

@end

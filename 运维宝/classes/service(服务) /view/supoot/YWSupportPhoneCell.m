//
//  YWSupportPhoneCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSupportPhoneCell.h"

@implementation YWSupportPhoneCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"supportPhoneCell";
    
    YWSupportPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWSupportPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *supportLab = [[UILabel alloc] init];
    self.supportLab = supportLab;
    supportLab.font = FONT_15;
    supportLab.text = @"柳林工区-柳林维修班  陈松";
    supportLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:supportLab];
    
    //设备名称
    UILabel *namePhone = [[UILabel alloc] init];
    self.namePhone = namePhone;
    namePhone.textColor = LOGINCLOLOR;
    namePhone.font = FONT_15;
    namePhone.text = @"18888888888";
    namePhone.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(namePhoneClick)];
    [namePhone addGestureRecognizer:tapGesturRecognizer];
    namePhone.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:namePhone];
    
    
    //设置frame
    
    [self.supportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(18);
        make.height.mas_equalTo(25);
    }];
    
    
    [self.namePhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.supportLab.mas_right).offset(20);
        //make.size.mas_equalTo(CGSizeMake(40, 40));
        
        make.height.mas_equalTo(25);
    }];
    
    
}

- (void)namePhoneClick
{
    if (self.didNamePhoneLab) {
        self.didNamePhoneLab(self.namePhone);
    }
    
}
@end

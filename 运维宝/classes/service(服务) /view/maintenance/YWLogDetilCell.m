//
//  YWLogDetilCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/5.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWLogDetilCell.h"
#import "YXTextView.h"

@implementation YWLogDetilCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"logDetilCell";
    
    YWLogDetilCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWLogDetilCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //类型
    UILabel *typeLab = [[UILabel alloc] init];
    self.typeLab = typeLab;
    typeLab.textAlignment = NSTextAlignmentCenter;
    typeLab.numberOfLines = 0;
    typeLab.text = @"服务类型:机械故障";
    typeLab.textColor = [UIColor darkGrayColor];
    typeLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.typeLab];
    
    //时间
    UILabel *dateLab = [[UILabel alloc] init];
    self.dateLab = dateLab;
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.numberOfLines = 0;
    dateLab.text = @"2017-10-20 10:30";
    dateLab.textColor = [UIColor darkGrayColor];
    dateLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.dateLab];

    UIView *bgView = [[UIView alloc]init];
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 0.5;
   
    [self.contentView addSubview:bgView];
    //描述
    UILabel *desLab = [[UILabel alloc] init];
    self.desLab = desLab;
   
    desLab.textAlignment = NSTextAlignmentNatural;
    desLab.numberOfLines = 0;
    desLab.text = @"断路器不能和闸刀，不能启动机器。可以免维护处理断路器不能和";
    desLab.textColor = [UIColor darkGrayColor];
    desLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:self.desLab];
    
    YXTextView *logDetilTv = [[YXTextView alloc] init];
    self.logDetilTv = logDetilTv;
    logDetilTv.userInteractionEnabled = NO;
    logDetilTv.textColor = [UIColor darkGrayColor];
    logDetilTv.placeholderColor = [UIColor lightGrayColor];
    logDetilTv.layer.borderWidth = 0.5;
    logDetilTv.layer.borderColor = LOGINCLOLOR.CGColor;
    logDetilTv.font = FONT_14;
   // [YWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:supportTv];
    [self.contentView addSubview:logDetilTv];
    
    //类型
    UILabel *nameLab = [[UILabel alloc] init];
    self.nameLab = nameLab;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.numberOfLines = 0;
    nameLab.text = @"报告人:王东";
    nameLab.textColor = [UIColor darkGrayColor];
    nameLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLab];
    
    //类型
    UILabel *phoneLab = [[UILabel alloc] init];
    self.phoneLab = phoneLab;
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.numberOfLines = 0;
    phoneLab.text = @"电话:18888888888";
    phoneLab.textColor = [UIColor darkGrayColor];
    phoneLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.phoneLab];
    
    
    
    //设置frame
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(15);
        make.height.mas_equalTo(18);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLab.mas_top);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(self).offset(-15);
    }];
    
    [self.logDetilTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 80));
        
    }];

//    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(bgView.mas_top).offset(5);
//        make.left.mas_equalTo(bgView.mas_left).offset(5);
//        make.right.mas_equalTo(bgView.mas_right).offset(-10);
//        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-5);
//        
//    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logDetilTv.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(15);
        make.bottom.mas_equalTo(self).offset(-10);
        
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.nameLab.mas_top);
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(self).offset(-10);
        
    }];
    
    
}

@end

//
//  YWStationDetilCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/21.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWStationDetilCell.h"
#import "YWDeviceDetil.h"

@implementation YWStationDetilCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"stationDetilCell";
    
    YWStationDetilCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWStationDetilCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *categoryLab = [[UILabel alloc] init];
    self.categoryLab = categoryLab;
    categoryLab.font = FONT_15;
    categoryLab.text = @"高压柜";
    categoryLab.textColor = [UIColor darkGrayColor];
    categoryLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:categoryLab];
    
    //状态按钮1
    UIButton *statusBtn1 = [[UIButton alloc] init];
    statusBtn1.tag = 3;
    statusBtn1.layer.cornerRadius = 8;
    statusBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [statusBtn1 setTitle:@"1" forState:UIControlStateNormal];
    [statusBtn1 setBackgroundImage:[UIImage imageNamed:@"fragment_main_gray_uncheck"] forState:UIControlStateNormal];
    //按钮点击
    [statusBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    statusBtn1.clipsToBounds = YES;
    [self.contentView addSubview:statusBtn1];
    self.statusBtn1 = statusBtn1;

    //状态按钮2
    UIButton *statusBtn2 = [[UIButton alloc] init];
    statusBtn2.tag = 0;
    statusBtn2.layer.cornerRadius = 8;
    statusBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [statusBtn2 setTitle:@"2" forState:UIControlStateNormal];
    [statusBtn2 setBackgroundImage:[UIImage imageNamed:@"fragment_main_green_uncheck"] forState:UIControlStateNormal];
    //按钮点击
    [statusBtn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    statusBtn2.clipsToBounds = YES;
    [self.contentView addSubview:statusBtn2];
    self.statusBtn2 = statusBtn2;

    //状态按钮3
    UIButton *statusBtn3 = [[UIButton alloc] init];
    statusBtn3.tag = 1;
    statusBtn3.layer.cornerRadius = 8;
    statusBtn3.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [statusBtn3 setTitle:@"3" forState:UIControlStateNormal];
    [statusBtn3 setBackgroundImage:[UIImage imageNamed:@"fragment_main_orange_uncheck"] forState:UIControlStateNormal];
    //按钮点击
    [statusBtn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    statusBtn3.clipsToBounds = YES;
    [self.contentView addSubview:statusBtn3];
    self.statusBtn3 = statusBtn3;

    //状态按钮4
    UIButton *statusBtn4 = [[UIButton alloc] init];
    statusBtn4.tag = 2;
    statusBtn4.layer.cornerRadius = 8;
    statusBtn4.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [statusBtn4 setTitle:@"4" forState:UIControlStateNormal];
    [statusBtn4 setBackgroundImage:[UIImage imageNamed:@"fragment_main_red_uncheck"] forState:UIControlStateNormal];
    //按钮点击
    [statusBtn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    statusBtn4.clipsToBounds = YES;
    [self.contentView addSubview:statusBtn4];
    self.statusBtn4 = statusBtn4;

    //设置frame
    
    [self.categoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(20);
        make.height.mas_equalTo(25);
    }];
    
    
    [self.statusBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.statusBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.statusBtn1.mas_left).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    [self.statusBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.statusBtn2.mas_left).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    [self.statusBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.statusBtn3.mas_left).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)btnClick:(UIButton *)button
{
    UIButton *btn = button;
    NSLog(@"%ld",btn.tag);
    //判断按钮是否可以点击啊交互
    //button.selected = !button.selected;
    if (button.currentTitle == 0) {
        button.userInteractionEnabled = NO;
    } else {
        button.userInteractionEnabled = YES;
    }
    
    if (_deviceBtnDidClick) {
        _deviceBtnDidClick(btn.tag);
    }
    

}

- (void)setDeviceDetil:(YWDeviceDetil *)deviceDetil
{
    
    _deviceDetil = deviceDetil;
    
    
    self.categoryLab.text = deviceDetil.class_name;
    [self.statusBtn1 setTitle:deviceDetil.offline forState:UIControlStateNormal];
    [self.statusBtn2 setTitle:deviceDetil.normal forState:UIControlStateNormal];
    [self.statusBtn3 setTitle:deviceDetil.attention forState:UIControlStateNormal];
    [self.statusBtn4 setTitle:deviceDetil.danger forState:UIControlStateNormal];
    
    
}

@end

//
//  YWMyDeviceCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWMyDeviceCell.h"
#import "YWMyDevice.h"

@implementation YWMyDeviceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"myDeviceCell";
    
    YWMyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWMyDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    // 设置左边显示一个放大镜
    UIImageView *colorView = [[UIImageView alloc] init];
    self.colorView = colorView;
    //self.colorView.backgroundColor = YWRandomColor;
    colorView.layer.cornerRadius = 5;
    colorView.clipsToBounds = YES;
    [self.contentView addSubview:colorView];
    
    UILabel *nameLab = [[UILabel alloc] init];
    self.nameLab = nameLab;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.numberOfLines = 0;
    nameLab.text = @"庆102柜";
    nameLab.textColor = [UIColor darkGrayColor];
    nameLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLab];
    
    
    UILabel *detilLab = [[UILabel alloc] init];
    self.detilLab = detilLab;
    detilLab.textAlignment = NSTextAlignmentCenter;
    detilLab.numberOfLines = 0;
    detilLab.text = @"220KV人民变电站";
    detilLab.textColor = [UIColor darkGrayColor];
    detilLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:detilLab];
    
    //设置frame
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.colorView.mas_right).offset(10);
        make.height.mas_equalTo(25);
    }];
    
    
    [self.detilLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(25);
    }];

    
}

//设置数据
- (void)setMyDevice:(YWMyDevice *)myDevice
{
    
    _myDevice = myDevice;
    
    if ([myDevice.status isEqualToString:@"0"]) {
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_green_uncheck"];
    } else if ([myDevice.status isEqualToString:@"1"]){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_orange_uncheck"];
    }else if ([myDevice.status isEqualToString:@"2"]){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_red_uncheck"];
    }else if ([myDevice.status isEqualToString:@"3"]){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
    }else{
        self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];

    }
    
    
    self.nameLab.text = myDevice.name;
    
    self.detilLab.text = myDevice.station;
    
    
    
}

 @end

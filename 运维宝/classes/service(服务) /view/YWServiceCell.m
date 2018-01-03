//
//  YWServiceCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWServiceCell.h"
#import "YWSercice.h"

@implementation YWServiceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"serviceCell";
    
    YWServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    // 设置左边显示一个颜色方块
    UIImageView *colorView = [[UIImageView alloc] init];
    self.colorView = colorView;
    //self.colorView.backgroundColor = YWRandomColor;
    colorView.layer.cornerRadius = 5;
    colorView.clipsToBounds = YES;
    [self.contentView addSubview:self.colorView];
    
    UILabel *nameLab = [[UILabel alloc] init];
    self.nameLab = nameLab;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.numberOfLines = 0;
    nameLab.text = @"庆102柜";
    nameLab.textColor = [UIColor darkGrayColor];
    nameLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLab];
    
    
    UILabel *detilLab = [[UILabel alloc] init];
    self.detilLab = detilLab;
    detilLab.textAlignment = NSTextAlignmentCenter;
    detilLab.numberOfLines = 0;
    detilLab.text = @"KYN28";
    detilLab.textColor = [UIColor darkGrayColor];
    detilLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.detilLab];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
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

- (void)setServices:(YWSercice *)services
{
    
    _services = services;
    
    if (services.status == 0) {
        self.colorView.image = [UIImage imageNamed:@"fragment_main_green_uncheck"];
    } else if (services.status == 1){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_orange_uncheck"];
    }else if (services.status == 2){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_red_uncheck"];
    }else if (services.status == 3){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
    }

    
    self.nameLab.text = services.name;
    
    
    self.detilLab.text = services.specification;
    
    
}

@end

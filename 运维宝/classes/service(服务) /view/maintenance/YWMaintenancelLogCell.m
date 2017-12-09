//
//  YWMaintenancelLogCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWMaintenancelLogCell.h"
#import "YWMaintenanceLog.h"

@implementation YWMaintenancelLogCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"maintenancelLogCell";
    
    YWMaintenancelLogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWMaintenancelLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *statusBtn = [[UIButton alloc] init];
    self.statusBtn = statusBtn;
    statusBtn.userInteractionEnabled = NO;
    statusBtn.titleLabel.font = FONT_14;
    [statusBtn setTitleColor:LOGINCLOLOR forState:UIControlStateNormal];
    [statusBtn setTitle:@"已完成" forState:UIControlStateNormal];
    [self.contentView addSubview:statusBtn];
    
    
    UILabel *detilLab = [[UILabel alloc] init];
    self.detilLab = detilLab;
    detilLab.textAlignment = NSTextAlignmentLeft;
    detilLab.numberOfLines = 0;
    detilLab.text = @"断路器不能和闸刀，不能启动机器。可以免维护处理断路器不能和闸刀，不能启动机器。可以免维护处理断路器不能和闸刀";
    detilLab.textColor = [UIColor darkGrayColor];
    detilLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.detilLab];
    
    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    titleLab.text = @"机械故障 状态:一般";
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLab];
    
    UILabel *nameLab = [[UILabel alloc] init];
    self.nameLab = nameLab;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.numberOfLines = 0;
    nameLab.text = @"报告人:王东";
    nameLab.textColor = [UIColor darkGrayColor];
    nameLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLab];
    
    UILabel *dateLab = [[UILabel alloc] init];
    self.dateLab = dateLab;
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.numberOfLines = 0;
    dateLab.text = @"2017-10-20 10:30";
    dateLab.textColor = [UIColor darkGrayColor];
    dateLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.dateLab];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    self.lineView.backgroundColor = COLOR_Line;
    self.lineView.alpha = 0.5;
    [self.contentView addSubview:self.lineView];
    
    //设置frame
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(15);

        make.height.mas_equalTo(18);
    }];

    [self.detilLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(self.nameLab.mas_top);
    }];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(8);
        make.right.mas_equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 20));
        
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self).offset(15);
        make.bottom.mas_equalTo(self).offset(-10);
        
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self).offset(-25);
        make.bottom.mas_equalTo(self).offset(-10);
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
}

//设置数据
- (void)setMaintenanceLog:(YWMaintenanceLog *)maintenanceLog
{
    
    _maintenanceLog = maintenanceLog;
    
    self.titleLab.text = [NSString stringWithFormat:@"%@  状态:%@",maintenanceLog.type,maintenanceLog.status];
    
    [self.statusBtn setTitle:maintenanceLog.is_dispose forState:UIControlStateNormal];
    
    self.detilLab.text = maintenanceLog.title;
    
    self.nameLab.text = [NSString stringWithFormat:@"报告人:%@",maintenanceLog.customer];
    
    self.dateLab.text = maintenanceLog.date;
    
}

@end

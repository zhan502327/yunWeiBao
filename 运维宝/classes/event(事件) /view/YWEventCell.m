//
//  YWEventCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWEventCell.h"
#import "YWEventModel.h"

@implementation YWEventCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"eventCell";
    
    YWEventCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    //self.iconView.backgroundColor = YWRandomColor;
    iconView.layer.cornerRadius = 5;
    iconView.clipsToBounds = YES;
    [self.contentView addSubview:self.iconView];
    
    //小红点
    CGFloat redViewWH = 10;
    UIView *redView = [[UIView alloc] init];
    self.redView = redView;
    redView.backgroundColor = [UIColor redColor];
    redView.layer.masksToBounds = YES;
    redView.layer.cornerRadius = redViewWH / 2;
    [self.contentView addSubview:redView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.numberOfLines = 0;
    titleLab.text = @"220KV农业路变电站";
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLab];
    
    
    UILabel *detilLab = [[UILabel alloc] init];
    self.detilLab = detilLab;
    detilLab.textAlignment = NSTextAlignmentLeft;
    detilLab.numberOfLines = 0;
    detilLab.text = @"断路器不能和闸刀，不能启动机器。可以免维护处理";
    detilLab.textColor = [UIColor darkGrayColor];
    detilLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.detilLab];
    
    UILabel *dateLab = [[UILabel alloc] init];
    self.dateLab = dateLab;
    dateLab.textAlignment = NSTextAlignmentLeft;
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
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconView.mas_top);
        make.right.mas_equalTo(self.iconView.mas_right).offset(2);
        make.size.mas_equalTo(CGSizeMake(redViewWH, redViewWH));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(5);
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-10);

//        make.height.mas_equalTo(20);
    }];
    
    
    [self.detilLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(0);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self).offset(-10);
       
    }];

//    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self).offset(5);
//        make.right.mas_equalTo(self).offset(-10);
//        //make.bottom.mas_equalTo(self).offset(-10);
//
//    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detilLab.mas_bottom).offset(2);
        make.left.mas_equalTo(self.detilLab);
        make.right.mas_equalTo(self.detilLab);
        make.height.mas_equalTo(20);

        //make.bottom.mas_equalTo(self).offset(-10);
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];

    
}

//设置数据
- (void)setEventModel:(YWEventModel *)eventModel
{
    _eventModel = eventModel;
 
    
//    if ([eventModel.isLooked isEqualToString:@"0"]) {
//        self.redView.hidden = NO;
//    }else{
//        self.redView.hidden = YES;
//    }
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:5];
    
    NSString *resultStr = [NSString stringWithFormat:@"%@    %@    %@",eventModel.station, eventModel.asset, eventModel.explain];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:resultStr];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [resultStr length])];
    
    // 设置Label要显示的text
    self.titleLab.attributedText = setString;
    
    
//    self.detilLab.text = eventModel.explain;
    self.detilLab.text = @"";

//    2018-01-03 23:59:00.720
    NSArray *strarray = [eventModel.happen_time componentsSeparatedByString:@"."];
    if (strarray.count > 0) {
        self.dateLab.text = strarray[0];
    }else{
        self.dateLab.text = @"";
    }
}


@end

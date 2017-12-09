//
//  YWProfileViewCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWProfileViewCell.h"

@implementation YWProfileViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"ProfileViewCell";
    
    YWProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWProfileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //提示标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"到账银行卡";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    //countLab.backgroundColor = [UIColor redColor];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:self.titleLabel];
    
   //账号详细
    UILabel *detilLabel = [[UILabel alloc] init];
    detilLabel.textAlignment = NSTextAlignmentCenter;
    detilLabel.hidden = YES;
    detilLabel.numberOfLines = 0;
    detilLabel.text = @"备注信息";
    detilLabel.textColor = [UIColor darkGrayColor];
    detilLabel.font = [UIFont systemFontOfSize:12];
    //numLab.backgroundColor = [UIColor redColor];
    self.detilLabel = detilLabel;
    [self.contentView addSubview:detilLabel];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    self.lineView.backgroundColor = COLOR_Line;
    self.lineView.alpha = 0.5;
    [self.contentView addSubview:self.lineView];
    
    //右边箭头
    UIImageView *arrow = [[UIImageView alloc] init];
    self.arrowImage = arrow;
    arrow.contentMode = UIViewContentModeScaleAspectFill;
    self.arrowImage.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self.contentView addSubview:arrow];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.detilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(13, 15));
    }];
    
}
@end

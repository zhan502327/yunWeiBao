//
//  YWCurrentStationCell.m
//  运维宝
//
//  Created by jiabin on 2017/11/13.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWCurrentStationCell.h"

@implementation YWCurrentStationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"currentStationCell";
    
    YWCurrentStationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWCurrentStationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
   
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    self.nameLabel.textColor = YWColor(70, 171, 211);
    self.nameLabel.text = @"当前电站:";
    nameLabel.font = FONT_15;
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [nameLabel sizeToFit];
    [self.contentView addSubview:nameLabel];
    
    UIButton *stationBtn = [[UIButton alloc] init];
    self.stationBtn = stationBtn;
    stationBtn.titleLabel.textColor = LOGINCLOLOR;
    stationBtn.titleLabel.font = FONT_15;
    stationBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    stationBtn.titleLabel.text = @"已完成";
    //选中状态
   [stationBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:stationBtn];
    
   
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.centerY.mas_equalTo(self);
        CGSize labSize = [nameLabel.text sizeWithFont:nameLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        make.size.mas_equalTo(CGSizeMake(labSize.width+5, labSize.height));
    }];
    
    [self.stationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right);
        CGSize btnSize = [nameLabel.text sizeWithFont:stationBtn.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        make.size.mas_equalTo(CGSizeMake(150,20));
        make.centerY.mas_equalTo(self);
    }];
    
}
//打对号按钮点击事件
- (void)checkBtnClick:(UIButton *)button
{
    //打对号按钮
    button.selected = !button.selected;
    
}


@end

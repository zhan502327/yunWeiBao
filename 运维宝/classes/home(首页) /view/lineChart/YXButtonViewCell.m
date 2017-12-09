//
//  YXButtonViewCell.m
//  运维宝
//
//  Created by jiabin on 2017/11/16.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YXButtonViewCell.h"

@implementation YXButtonViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"buttonViewCell";
    
    YXButtonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YXButtonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    //状态按钮1
    UIButton *titleBtn = [[UIButton alloc] init];
    self.titleBtn = titleBtn;
    titleBtn.userInteractionEnabled = NO;
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [titleBtn setTitle:@"1周" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[titleBtn setBackgroundImage:[UIImage imageNamed:@"fragment_main_gray_uncheck"] forState:UIControlStateNormal];厦门
    //按钮点击
    [titleBtn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:self.titleBtn];
    
    //设置frame
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleBtn.frame = self.bounds;
}

//时间按钮点击
- (void)timeBtnClick
{
    if (self.didTapTimeBtn) {
        self.didTapTimeBtn(self.titleBtn);
    }
}

- (void)setTitleBtn:(UIButton *)titleBtn
{
    _titleBtn = titleBtn;
}


@end

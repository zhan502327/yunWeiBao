//
//  HomeHedaerView.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "HomeHedaerView.h"

@implementation HomeHedaerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllView];
    }
    
    
    return self;
}

#pragma mark - setUpUI
- (void)setUpAllView
{

    // 设置顶部图片
    UIImageView *headerPicView = [[UIImageView alloc] init];
    headerPicView.image = [UIImage imageNamed:@"banner"];
    headerPicView.contentMode = UIViewContentModeScaleAspectFit;
    self.headerPicView = headerPicView;
    //self.headerPicView.backgroundColor = YWRandomColor;
    
    
    [self addSubview:headerPicView];
    
    //设置frame
    [self.headerPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat iconViewWH = 68;
    //self.headerPicView.frame = CGRectMake((self.width - iconViewWH) * 0.5, 30, iconViewWH, iconViewWH);
    CGFloat iconXY = (self.height-iconViewWH-60)*0.5;
    //CGFloat icon = iconX;
    
    //self.headerPicView.frame = CGRectMake(iconXY, iconXY, iconViewWH, iconViewWH);
    //self.loginBtn.frame = self.bounds;
}




@end

#pragma mark -自定义按钮
@implementation YWhederButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllView];
    }
    
    
    return self;
}

#pragma mark - setUpUI
- (void)setUpAllView
{
  
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat iconViewWH = 68;
    //self.iconView.frame = CGRectMake((self.width - iconViewWH) * 0.5, 30, iconViewWH, iconViewWH);
    CGFloat iconXY = (self.height-iconViewWH-60)*0.5;
    //CGFloat icon = iconX;
    
    //self.headerPicView.frame = CGRectMake(iconXY, iconXY, iconViewWH, iconViewWH);
    //self.loginBtn.frame = self.bounds;
}


@end


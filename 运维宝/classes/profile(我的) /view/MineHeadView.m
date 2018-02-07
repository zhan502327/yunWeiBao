//
//  MineHeadView.m
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "MineHeadView.h"

@interface MineHeadView ()

@property (nonatomic,weak) UIButton *loginBtn;
@end

#pragma mark - MineHeadView

@implementation MineHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame loginButtonClick:(void (^)())loginButtonClickBlock{
    if (self = [super init]) {
        
        self.loginButtonClickBlock = loginButtonClickBlock;
    }
    return self;
}

#pragma mark - 私有方法
#pragma mark - setUpUI
- (void)setUpUI{
    self.image = [UIImage imageNamed:@"iconbg"];
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    [login addTarget:self action:@selector(setUpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:login];
    self.userInteractionEnabled = true;
    self.loginBtn = login;
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    self.lineView.backgroundColor = COLOR_Line;
    self.lineView.alpha = 0.5;
    [self addSubview:self.lineView];
    
    IconView *iconView = [[IconView alloc] init];
    iconView.iconImageView.image = [UIImage imageNamed:@"push"];
    //iconView.backgroundColor = [UIColor redColor];
    [self addSubview:iconView];
    self.iconView = iconView;
}

- (void)setUpButtonClick{
    if (_loginButtonClickBlock) {
        self.loginButtonClickBlock();
    }
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat iconViewWH = 85;
    
    CGFloat iconXY = (self.height-iconViewWH-60)*0.5;
    
    self.iconView.frame = CGRectMake((self.width - iconViewWH) * 0.5,iconXY, iconViewWH, iconViewWH);
    self.lineView.frame = CGRectMake(0,self.height-0.5, SCREEN_WIDTH, 0.5);
    
    self.loginBtn.frame = self.bounds;
}

@end

#pragma mark - IconView

@implementation IconView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - 私有方法
#pragma mark - setUpUI
- (void)setUpUI{
    UIImageView *icon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_big"]];
    icon.userInteractionEnabled = YES;
    self.iconImageView = icon;
    //icon.backgroundColor = [UIColor orangeColor];
    [self addSubview:_iconImageView];
    
//    UILabel *phone = [[UILabel alloc] init];
//    //phone.backgroundColor = [UIColor blueColor];
//    [self addSubview:phone];
//    self.phoneNum = phone;
//    _phoneNum.text = @"登录／注册";
//    //_phoneNum.text = @"15838016766";
//    _phoneNum.font = FONT_16;
//    _phoneNum.textColor = [UIColor blackColor];
//    _phoneNum.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconX = 0;
    CGFloat iconY = 0;
    CGFloat iconW = _iconImageView.size.width;
    CGFloat iconH = _iconImageView.size.height;
   // _iconImageView.layer.cornerRadius = _iconImageView.size.width * 0.5;
   // _iconImageView.layer.masksToBounds = YES;
    
    _iconImageView.frame = CGRectMake(iconX,iconY, iconW, iconH);
    
//    CGFloat phoneW = 130;
//    CGFloat phoneH = 30;
//    CGFloat phoneY = (_iconImageView.height - phoneH)*0.5;
//    _phoneNum.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame),phoneY, phoneW, phoneH);
    
}



@end

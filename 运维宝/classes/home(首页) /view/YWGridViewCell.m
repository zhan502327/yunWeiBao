//
//  YWGridViewCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWGridViewCell.h"
#import "YWDeviceStatusNum.h"

@interface YWGridViewCell ()

@end

@implementation YWGridViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpAllView];
        
    }
    return self;
}

- (void)setUpAllView
{
    UIButton *statusBtn = [[UIButton alloc] init];
    self.statusBtn = statusBtn;
    statusBtn.userInteractionEnabled = NO;
    statusBtn.backgroundColor = REDCLOLOR;
    statusBtn.layer.cornerRadius = 10;
    statusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [statusBtn setTitle:@"68" forState:UIControlStateNormal];
    statusBtn.clipsToBounds = YES;
    [self addSubview:self.statusBtn];
    
    
    
    UILabel *statusLabel = [[UILabel alloc] init];
    self.statusLabel = statusLabel;
    statusLabel.font = FONT_13;
    statusLabel.text = @"设备";
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:statusLabel];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self)setOffset:YWMargin*0.4];
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerX.mas_equalTo(self);
        
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self.statusBtn.mas_bottom)setOffset:5];
    }];

}


- (void)setStatusBtn:(UIButton *)statusBtn
{
    _statusBtn = statusBtn;
    
    
    
}

@end

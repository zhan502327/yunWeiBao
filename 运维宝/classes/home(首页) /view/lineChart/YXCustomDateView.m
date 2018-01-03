//
//  YXCustomDateView.m
//  运维宝
//
//  Created by jiabin on 2017/11/14.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YXCustomDateView.h"


@interface YXCustomDateView ()

/**文字*/
@property (strong, nonatomic) UILabel *titleLabel;

@end


@implementation YXCustomDateView
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_16;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = self.bounds;
        
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    self.clearsContextBeforeDrawing = YES;
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self == [super initWithCoder:decoder]) {
    }
    
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
    
}
@end

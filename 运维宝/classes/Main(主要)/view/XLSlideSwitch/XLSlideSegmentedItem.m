//
//  XLSlideSegmentItem.m
//  实体联盟
//
//  Created by 贾斌 on 2017/7/7.
//  Copyright © 2017年 贾斌. All rights reserved.
//
#import "XLSlideSegmentedItem.h"

@implementation XLSlideSegmentedItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    _textLabel = [[UILabel alloc] init];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

@end

//
//  PrefixHeader.pch
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "SCSearchBar.h"

@implementation SCSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 设置字体
        self.font = [UIFont systemFontOfSize:16];
        
        // 设置背景
        self.background = [UIImage resizedImage:@"searchbar_textfield_background"];
        // 设置左边的view
        [self setLeftView];
        
        // 设置右边的录音按钮
        [self setRightView];
        
    }
    
    return self;
}

- (instancetype)init {
    // 设置frame
    CGFloat width = SCREEN_WIDTH - 120;
    CGFloat height = 30;
    CGFloat X = (SCREEN_WIDTH - width) * 0.5;
    CGFloat Y = 7;
    CGRect frame = CGRectMake(X, Y, width, height);
    
    return [self initWithFrame:frame];
}

// 设置左边的view
- (void)setLeftView {
    
    // initWithImage:默认UIImageView的尺寸跟图片一样
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 5)];
    
    self.leftView = leftView;
    //self.leftView = leftImageView;
    //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
    self.leftViewMode = UITextFieldViewModeAlways;
}

// 设置右边的view
- (void)setRightView {
    // 创建按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    // 将imageView宽度
    rightButton.width += 10;
    //居中
    rightButton.contentMode = UIViewContentModeCenter;

    [rightButton addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = rightButton;
    //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
    self.rightViewMode = UITextFieldViewModeAlways;
    
}

//放大镜点击处理
- (void)butClick
{
    if (self.didTapSearchbar) {
        self.didTapSearchbar(self.text);
    }
}
@end 

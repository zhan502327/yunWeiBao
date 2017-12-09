//
//  YXTextView.m
//  运维宝
//
//  Created by 斌  on 2017/10/27.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YXTextView.h"

@interface YXTextView()

/**文字*/
@property (nonatomic, weak) UILabel *placeholderLab;
@end

@implementation YXTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //添加提示文字
        UILabel *placehoderLab = [[UILabel alloc] init];
        self.placeholderLab = placehoderLab;
        placehoderLab.textColor = [UIColor lightGrayColor];
        placehoderLab.hidden = YES;
        placehoderLab.numberOfLines = 0;
        placehoderLab.backgroundColor = [UIColor clearColor];
        placehoderLab.font = self.font;
        [self insertSubview:placehoderLab atIndex:0];
        
        //监听textview文字改变的通知
        [YWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    //_placeholder = placeholder;
    self.placeholderLab.text = placeholder;
    
    if (placeholder.length) {//需要显示
        self.placeholderLab.hidden = NO;
        
        //计算frame
        CGFloat placeholderX = 5;
        CGFloat placeholderY = 7;
        CGFloat maxW = self.frame.size.width - placeholderX*2;
        CGFloat maxH = self.frame.size.height - placeholderY*2;
        // 1.计算文字的尺寸
        //CGSize titleSize = [title sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGSize placeholderSize = [placeholder sizeWithFont:self.placeholderLab.font maxSize:CGSizeMake(maxW, maxH)];
        self.placeholderLab.frame  = CGRectMake(placeholderX, placeholderY, placeholderSize.width, placeholderSize.height);
        
    }else{
        
        self.placeholderLab.hidden = YES;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    //设置文字颜色
    self.placeholderLab.textColor = placeholderColor;
    
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLab.font = font;
    //self.placeholder = self.placeholder;
    
}

- (void)textDidChange
{
    //判断文字是否显示
    self.placeholderLab.hidden = (self.text.length != 0);
}

//移除通知监听
- (void)dealloc
{
    [YWNotificationCenter removeObserver:self];
}


@end

//
//  YXTextView.h
//  运维宝
//
//  Created by 斌  on 2017/10/27.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTextView : UITextView
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/**占位文字颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;

@end

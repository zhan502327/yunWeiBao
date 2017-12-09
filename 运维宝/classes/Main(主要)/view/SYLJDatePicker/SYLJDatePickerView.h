//
//  SYLJDatePickerView.h
//  SYLJDatePicker
//
//  Created by 一天一天 on 2017/3/10.
//  Copyright © 2017年 一天一天. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dateSelBlock)(NSString *dateString);

/**
 是获取出生日期还是有效期

 - SYLJDatePickerTypeBirthdayDate: 出生日期
 - SYLJDatePickerTypeValidityDate: 有效期
 - SYLJDatePickerTypeOther:
 */
typedef NS_ENUM(NSUInteger, SYLJDatePickerTypes) {
    SYLJDatePickerTypeBirthdayDate,
    SYLJDatePickerTypeValidityDate,
};

/*!
 获取出生日期或有效期
 
 作用:
 选择出生日期或证件有效期
 
 使用:
 
 @code
 
 // 实例化控制器，并指定完成回调
 SYLJDatePickerView *datePicker = [[SYLJDatePickerView alloc] initWithDatePickerType:SYLJDatePickerTypeBirthdayDate dateSelBlock:^(NSString *dateString) {
 NSLog(@"%@",dateString);
 }];
 [datePicker showDatePicker];
 
 @endcode
 
 @note 出生日期默认是从当前时间 - 120 年开始，
 有效期默认截至时间是当前时间 + 120
 */

@interface SYLJDatePickerView : UIView

/**
 创建日期选择器

 @param datePickerType 查询类型
 @param dateSelBlock 查询结果
 @return 日期选择器
 */
- (instancetype)initWithDatePickerType:(SYLJDatePickerTypes) datePickerType dateSelBlock:(dateSelBlock)dateSelBlock;

/**
 日期结果回调
 */
@property (nonatomic, copy) dateSelBlock dateSelBlock;

/**
 日期选择器
 */
@property (nonatomic, strong) UIDatePicker *datePicker;

/**
 显示日期选择器
 */
- (void)showDatePicker;

/**
 隐藏日期选择器
 */
- (void)hideDatePicker;

@end

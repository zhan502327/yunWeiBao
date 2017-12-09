//
//  SYLJDatePickerView.m
//  SYLJDatePicker
//
//  Created by 一天一天 on 2017/3/10.
//  Copyright © 2017年 一天一天. All rights reserved.
//

#import "SYLJDatePickerView.h"

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kDatePickerToolHeight   40
#define kDatePickerHeight   216
#define kSureButtonWidth    61
#define kSureButtonHeight   31

#define kDateInterval   60

@interface SYLJDatePickerView ()

@property (nonatomic, assign) SYLJDatePickerTypes datePickerType;

@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView *dividingline;

@end

@implementation SYLJDatePickerView

- (instancetype)initWithDatePickerType:(SYLJDatePickerTypes) datePickerType dateSelBlock:(dateSelBlock)dateSelBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.datePickerType = datePickerType;
        self.dateSelBlock = dateSelBlock;
        
        [self prepareUI];
        [self setupAction];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
        [self setupAction];
    }
    return self;
}

- (void)prepareUI
{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self addSubview:self.toolsView];
    
    [self.toolsView addSubview:self.sureBtn];
    [self.toolsView addSubview:self.dividingline];
    [self.toolsView addSubview:self.datePicker];
}

- (void)setupAction
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePicker)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - 
#pragma mark Action methods
- (void)showDatePicker
{
    self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.toolsView.frame = CGRectMake(0, kScreenHeight - kDatePickerHeight - kDatePickerToolHeight, kScreenWidth, kDatePickerToolHeight + kDatePickerHeight);
    } completion:^(BOOL finished) {
        [self setingDateInterval];
    }];
}

- (void)hideDatePicker
{
    self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.toolsView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kDatePickerToolHeight + kDatePickerHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)onSure:(UIButton*)sender
{
    [self hideDatePicker];
    
    self.dateSelBlock ? self.dateSelBlock([self stringFromDate:self.datePicker.date]) : nil;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //加上时间
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark - 
#pragma mark - Feature methods
- (void)setingDateInterval
{
    if (self.datePickerType == SYLJDatePickerTypeBirthdayDate) {
        [self setingBirthdayDateInterval];
    } else {
        [self setingValidityDateInterval];
    }
}

//计算120年前的日期
- (void)setingBirthdayDateInterval
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *minimumComponents = [[NSDateComponents alloc] init];
    [minimumComponents setYear:components.year - kDateInterval];
    [minimumComponents setMonth:components.month];
    [minimumComponents setDay:components.day];
    NSDate *minimum = [calendar dateFromComponents:minimumComponents];
    
    self.datePicker.minimumDate = minimum;
    self.datePicker.maximumDate = [NSDate date];
}

//计算120年后的日期
- (void)setingValidityDateInterval
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *maximumComponents = [[NSDateComponents alloc] init];
    [maximumComponents setYear:components.year + kDateInterval];
    [maximumComponents setMonth:components.month];
    [maximumComponents setDay:components.day];
    NSDate *maximumDate = [calendar dateFromComponents:maximumComponents];
    
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.maximumDate = maximumDate;
}

#pragma mark -
#pragma mark setter methods
- (UIView *)toolsView
{
    if (_toolsView == nil) {
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kDatePickerHeight + kDatePickerToolHeight)];
        _toolsView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 /255.0 alpha:1.0];
    }
    return _toolsView;
}

- (UIButton *)sureBtn
{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _sureBtn.frame = CGRectMake(kScreenWidth - kSureButtonWidth -13, (kDatePickerToolHeight - kSureButtonHeight) * 0.5, kSureButtonWidth, kSureButtonHeight);
        [_sureBtn setBackgroundColor:[UIColor colorWithRed:96 / 255.0 green:217 / 255.0 blue:255 /255.0 alpha:1.0]];
        [_sureBtn addTarget:self action:@selector(onSure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIView *)dividingline
{
    if (_dividingline == nil) {
        _dividingline = [[UIView alloc] initWithFrame:CGRectMake(0, kDatePickerToolHeight - 1, kScreenWidth, 1)];
        _dividingline.backgroundColor = [UIColor colorWithRed:218 / 255.0 green:218 / 255.0 blue:218 / 255.0 alpha:1.0];
    }
    return _dividingline;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kDatePickerToolHeight, kScreenWidth, kDatePickerHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        
    }
    return _datePicker;
}

@end

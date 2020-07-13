//
//  YWHistoryTempCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

//#import "YWHistoryTempCell.h"
#import "YWHistoryTempCell.h"
#import "YWDeviceTempInfo.h"




@implementation YWHistoryTempCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"historyTempCell";
    
    YWHistoryTempCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWHistoryTempCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor  = [UIColor clearColor];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    
    //状态按钮1
    UIButton *statusBtn = [[UIButton alloc] init];
    self.statusBtn = statusBtn;
    statusBtn.userInteractionEnabled = NO;
    
    statusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    statusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    //[statusBtn setTitle:@"A相" forState:UIControlStateNormal];
    [statusBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [statusBtn setImage:[UIImage imageNamed:@"shippingAddressEdit"] forState:UIControlStateNormal];
    [self.contentView addSubview:statusBtn];
    //设备名称
    UIButton *tempBtn1 = [[UIButton alloc] init];
    self.tempBtn1 = tempBtn1;
    tempBtn1.selected = YES;
    tempBtn1.layer.cornerRadius = 3;
    tempBtn1.clipsToBounds = YES;
    //tempBtn1.layer.borderWidth = 1.5;
    tempBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [tempBtn1 setTitle:@"C相" forState:UIControlStateNormal];
    [tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tempBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tempBtn1.tintColor = [UIColor greenColor];
    [tempBtn1 addTarget:self action:@selector(CbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tempBtn1];
    
    
    UIButton *tempBtn2 = [[UIButton alloc] init];
    self.tempBtn2 = tempBtn2;
    tempBtn2.selected = YES;
    tempBtn2.layer.cornerRadius = 3;
    tempBtn2.clipsToBounds = YES;
    //tempBtn2.layer.borderWidth = 1.5;
    tempBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [tempBtn2 setTitle:@"B相" forState:UIControlStateNormal];
    tempBtn2.tintColor = [UIColor greenColor];
    tempBtn2.layer.borderColor = [UIColor whiteColor].CGColor;
    [tempBtn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [tempBtn2 addTarget:self action:@selector(BbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tempBtn2];
    
    UIButton *tempBtn3 = [[UIButton alloc] init];
    self.tempBtn3 = tempBtn3;
    tempBtn3.selected = YES;
    tempBtn3.layer.cornerRadius = 3;
    tempBtn3.clipsToBounds = YES;
    //tempBtn3.layer.borderWidth = 1.5;
    tempBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tempBtn3.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [tempBtn3 setTitle:@"A相" forState:UIControlStateNormal];
    
    tempBtn3.tintColor = [UIColor redColor];
    [tempBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tempBtn3 addTarget:self action:@selector(AbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tempBtn3];
    
    //设置frame
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        
    }];
    
    [self.tempBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(kTemperatureButtonWidth, 25));
    }];
    
    [self.tempBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.tempBtn1.mas_left).offset(-20);
        make.size.mas_equalTo(CGSizeMake(kTemperatureButtonWidth, 25));
        
    }];
    
    [self.tempBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.tempBtn2.mas_left).offset(-20);;
        make.size.mas_equalTo(CGSizeMake(kTemperatureButtonWidth, 25));
        
    }];
    
}

/**qq*/
- (void)CbtnClick:(UIButton *)button
{

    
    button.selected = !button.selected;
    if (self.didTapCBtn) {
        self.didTapCBtn(self.tempBtn1);
    }
    
}
/**微信*/
- (void)BbtnClick:(UIButton *)button
{
   
    button.selected = !button.selected;
    if (self.didTapBBtn) {
        self.didTapBBtn(self.tempBtn2);
    }
    
}

/**短信*/
- (void)AbtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (self.didTapABtn) {
        self.didTapABtn(self.tempBtn3);
    }
    
}

- (void)setTempInfo:(YWDeviceTempInfo *)tempInfo
{
    
    _tempInfo = tempInfo;
   
    NSString *astr = [NSString stringWithFormat:@"%@℃",tempInfo.a];
   [self.tempBtn3 setTitle:astr forState:UIControlStateNormal];

     NSString *bstr = [NSString stringWithFormat:@"%@℃",tempInfo.b];
    [self.tempBtn2 setTitle:bstr forState:UIControlStateNormal];

     NSString *cstr = [NSString stringWithFormat:@"%@℃",tempInfo.c];
    [self.tempBtn1 setTitle:cstr forState:UIControlStateNormal];
    
}

@end

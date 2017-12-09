//
//  YWDeviceInfoCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/23.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceInfoCell.h"
#import "YWDeviceInfo.h"

@implementation YWDeviceInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"deviceInfoCell";
    
    YWDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWDeviceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    //设备名称
    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    titleLab.font = FONT_14;
    titleLab.text = @"制造商";
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLab];
    
    UILabel *detilLab = [[UILabel alloc] init];
    detilLab.userInteractionEnabled = YES;
    self.detilLab = detilLab;
    detilLab.font = FONT_14;
    detilLab.text = @"江苏东源电器集团有限公司";
    detilLab.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detilLabClick)];
    [detilLab addGestureRecognizer:tapGesturRecognizer];
    [self.contentView addSubview:detilLab];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    self.lineView.backgroundColor = COLOR_Line;
    self.lineView.alpha = 0.5;
    [self.contentView addSubview:self.lineView];
    
    //设置frame
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 30));
        
    }];
    
    [self.detilLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];

}

- (void)detilLabClick
{
    if (self.didNamePhoneLab) {
        self.didNamePhoneLab(self.detilLab);
    }
    
}
//设备信息
- (void)setDeviceInfo:(YWDeviceInfo *)deviceInfo{
    
    _deviceInfo = deviceInfo;
    
    self.titleLab.text = deviceInfo.assets_name;
    
    self.detilLab.text = deviceInfo.brand_name;
    
}
 
@end

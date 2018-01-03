//
//  YWDeviceDocCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceDocCell.h"
#import "YWDeviceDocs.h"

@implementation YWDeviceDocCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"deviceDocCell";
    
    YWDeviceDocCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWDeviceDocCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    titleLab.text = @"说明书";
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLab];
    
    UILabel *detilLab = [[UILabel alloc] init];
    self.detilLab = detilLab;
    detilLab.font = FONT_14;
    detilLab.text = @"2017-11-11";
    detilLab.textAlignment = NSTextAlignmentRight;
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
        make.size.mas_equalTo(CGSizeMake(220, 30));
        
    }];
    
    [self.detilLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
}

 //设备文档
- (void)setDeviceDoc:(YWDeviceDocs *)deviceDoc
{
    
    _deviceDoc = deviceDoc;
    
    self.titleLab.text = deviceDoc.document_name;
    
    self.detilLab.text = deviceDoc.write_date;
    
    
    
}

@end

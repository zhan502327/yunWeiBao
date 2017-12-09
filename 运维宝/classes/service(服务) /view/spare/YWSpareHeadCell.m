//
//  YWSpareHeadCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSpareHeadCell.h"

@interface YWSpareHeadCell ()

/**1类别按钮*/
@property (nonatomic, weak) UILabel *spareLab1;
/**2类别按钮*/
@property (nonatomic, weak) UILabel *spareLab2;
/**3类别按钮*/
@property (nonatomic, weak) UILabel *spareLab3;
/**4类别按钮*/
@property (nonatomic, weak) UILabel *spareLab4;

@end

@implementation YWSpareHeadCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"spareHeadCell";
    
    YWSpareHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWSpareHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    UILabel *spareLab1 = [[UILabel alloc] init];
    self.spareLab1 = spareLab1;
    spareLab1.font = FONT_14;
    spareLab1.text = @"库存地址";
    spareLab1.textColor = [UIColor darkGrayColor];
    spareLab1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:spareLab1];
    
    UILabel *spareLab2 = [[UILabel alloc] init];
    self.spareLab2 = spareLab2;
    spareLab2.font = FONT_14;
    spareLab2.text = @"数量";
    spareLab2.textColor = [UIColor darkGrayColor];
    spareLab2.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:spareLab2];

    UILabel *spareLab3 = [[UILabel alloc] init];
    self.spareLab3 = spareLab3;
    spareLab3.font = FONT_14;
    spareLab3.text = @"备件型号";
    spareLab3.textColor = [UIColor darkGrayColor];
    spareLab3.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:spareLab3];

    UILabel *spareLab4 = [[UILabel alloc] init];
    self.spareLab4 = spareLab4;
    spareLab4.font = FONT_14;
    spareLab4.text = @"备件名称";
    
    spareLab4.textColor = [UIColor darkGrayColor];
    spareLab4.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:spareLab4];

    
    [self.spareLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.35, 40));
    }];
    
    [self.spareLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.spareLab1.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.10, 40));
        
    }];
    [self.spareLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.spareLab2.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.23, 40));
        
    }];
    
    [self.spareLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.spareLab3.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.28, 40));
        
    }];
    
    
}

@end

//
//  YWSerchResultCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/12.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSerchResultCell.h"
#import "YWSerch.h"

@implementation YWSerchResultCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"serchCell";
    
    
    YWSerchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWSerchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    // 设置左边显示一个放大镜
    UIImageView *colorView = [[UIImageView alloc] init];
    self.colorView = colorView;
    //self.colorView.backgroundColor = YWRandomColor;
    colorView.layer.cornerRadius = 5;
    colorView.clipsToBounds = YES;
    [self.contentView addSubview:colorView];
    
    UILabel *nameLab = [[UILabel alloc] init];
    self.nameLab = nameLab;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.numberOfLines = 0;
    nameLab.text = @"220KV人民变电站";
    nameLab.textColor = [UIColor darkGrayColor];
    nameLab.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:nameLab];
    
    //设置frame
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.colorView.mas_right).offset(10);
        make.height.mas_equalTo(25);
    }];
    
    
    //    [self.detilLab mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(self);
    //        make.right.mas_equalTo(self).offset(-15);
    //        make.height.mas_equalTo(25);
    //    }];
    
}


- (void)setSerch:(YWSerch *)serch
{
    _serch = serch;
    
    self.nameLab.text = serch.assets_name;
    
    if (serch.status == 0) {
        self.colorView.image = [UIImage imageNamed:@"fragment_main_green_uncheck"];
    } else if (serch.status == 1){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_orange_uncheck"];
    }else if (serch.status == 2){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_red_uncheck"];
    }else if (serch.status == 3){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
    }
    
}

@end

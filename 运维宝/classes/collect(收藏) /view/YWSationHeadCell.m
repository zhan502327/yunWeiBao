//
//  YWSationHeadCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/21.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSationHeadCell.h"
#import "YWDeviceDetilInfo.h"

@implementation YWSationHeadCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"stationHeadCell";
    
    YWSationHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWSationHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    // 设置左边色标和名称
    UIImageView *colorView = [[UIImageView alloc] init];
    self.colorView = colorView;
    
    //self.colorView.backgroundColor = YWRandomColor;
    colorView.layer.cornerRadius = 5;
    colorView.clipsToBounds = YES;
    [self.contentView addSubview:colorView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    titleLab.text = @"220KV人民变电站";
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLab];
    
    
    // 设置左边色标和名称
    UIButton *collectView = [[UIButton alloc] init];
    self.collectView = collectView;
    //self.collectView.backgroundColor = YWRandomColor;
    //[collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_yishouchang"] forState:UIControlStateSelected];
    //[collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_shouchang"] forState:UIControlStateNormal];
    [collectView addTarget:self action:@selector(collectViewBtnClick:) forControlEvents:UIControlEventTouchDown];
   
    //collectView.layer.cornerRadius = 5;
    //collectView.clipsToBounds = YES;
    [self.contentView addSubview:collectView];
    
    UIButton *tempBtn = [[UIButton alloc] init];
    self.tempBtn = tempBtn;
    tempBtn.userInteractionEnabled = NO;
    //tempBtn.backgroundColor = REDCLOLOR;
    //tempBtn.layer.cornerRadius = 10;
    tempBtn.titleLabel.font = FONT_15;
    [tempBtn setImage:[UIImage imageNamed:@"activity_wodedianzhan_wendu"] forState:UIControlStateNormal];
    
    [tempBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //tempBtn.clipsToBounds = YES;
    [self.contentView addSubview:tempBtn];
    
    UIButton *waterBtn = [[UIButton alloc] init];
    self.waterBtn = waterBtn;
    waterBtn.userInteractionEnabled = NO;
    [waterBtn setImage:[UIImage imageNamed:@"activity_wodedianzhan_shidu"] forState:UIControlStateNormal];
    //waterBtn.backgroundColor = REDCLOLOR;
    //waterBtn.layer.cornerRadius = 10;
    waterBtn.titleLabel.font = FONT_15;
    
    [waterBtn setTitle:@"0" forState:UIControlStateNormal];
   
    [waterBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:waterBtn];
    
    //设置frame
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(12);
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(8);
        make.left.mas_equalTo(self.colorView.mas_right).offset(10);
        make.height.mas_equalTo(25);
    }];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    
    }];
    
    [self.tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectView.mas_bottom).offset(15);
        make.right.mas_equalTo(self.waterBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
    
    [self.waterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectView.mas_bottom).offset(15);
        make.right.mas_equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    
    }];
   
}

//设置按钮点击状态
- (void)collectViewBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    
//    if (button.selected) {
//        [self.collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_yishouchang"] forState:UIControlStateSelected];
//    } else {
//        [self.collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_shouchang"] forState:UIControlStateNormal];
//    }
    
    if (self.collectBtnDidClick) {
        self.collectBtnDidClick();
    }
    if ([self.delegate respondsToSelector:@selector(collectionBtnClick:)]) {
        [self.delegate collectionBtnClick:self];
    }
    
}

- (void)setDetilInfo:(YWDeviceDetilInfo *)detilInfo
{
    _detilInfo = detilInfo;
    if (detilInfo.status == 0) {
        self.colorView.image = [UIImage imageNamed:@"fragment_main_green_uncheck"];
    } else if (detilInfo.status == 1){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_orange_uncheck"];
    }else if (detilInfo.status == 2){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_red_uncheck"];
    }else if (detilInfo.status == 3){
        
        self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
    }
    
    if (detilInfo.is_collection) {
        [self.collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_yishouchang"] forState:UIControlStateNormal];
    } else {
        [self.collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_shouchang"] forState:UIControlStateNormal];
    }
    NSString *tempStr = [NSString stringWithFormat:@"%@℃",detilInfo.tmp];
    [self.tempBtn setTitle:tempStr forState:UIControlStateNormal];
    NSString *str = @"%";
    NSString *waterStr = [NSString stringWithFormat:@"%@%@",detilInfo.hum,str];
    [self.waterBtn setTitle:waterStr forState:UIControlStateNormal];
    
}
@end

//
//  YWSerchViewCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSerchViewCell.h"
#import "SCSearchBar.h"

@implementation YWSerchViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"serchViewCell";
    
    YWSerchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWSerchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    // 1. 创建searchBar
    SCSearchBar *searchBar = [[SCSearchBar alloc] init];
    searchBar.placeholder = @"请输入查找的内容";
    self.searchBar = searchBar;
    [self.contentView addSubview:searchBar];
    // 设置左边显示一个放大镜
    UIImageView *scanView = [[UIImageView alloc] init];
    self.scanView = scanView;
    scanView.image = [UIImage imageNamed:@"scan_icon"];
    //self.scanView.backgroundColor = YWRandomColor;
    scanView.layer.cornerRadius = 5;
    scanView.clipsToBounds = YES;
    //添加手势
    [scanView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScan)]];
    scanView.userInteractionEnabled = YES;
    [self.contentView addSubview:scanView];
    
    UILabel *serchLab = [[UILabel alloc] init];
    self.serchLab = serchLab;
    serchLab.textAlignment = NSTextAlignmentCenter;
    serchLab.numberOfLines = 0;
    serchLab.text = @"搜索";
    serchLab.textColor = [UIColor darkGrayColor];
    serchLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:serchLab];
    
    
    UILabel *detilLab = [[UILabel alloc] init];
    self.detilLab = detilLab;
    detilLab.textAlignment = NSTextAlignmentCenter;
    detilLab.numberOfLines = 0;
    detilLab.text = @"当前电站: ";
    detilLab.textColor = [UIColor darkGrayColor];
    detilLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:detilLab];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    self.lineView.backgroundColor = COLOR_Line;
    self.lineView.alpha = 0.5;
    [self.contentView addSubview:self.lineView];
    
    //设置frame
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.serchLab.mas_right).offset(10);
        make.right.mas_equalTo(self.scanView.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.serchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 18));

    }];

    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];

}

- (void)didTapScan
{
    if (self.didTapScanView) {
        self.didTapScanView();
    }
}
@end

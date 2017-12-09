//
//  YWSupportLineCell.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSupportLineCell.h"
#import "YWOnlineInfo.h"

@implementation YWSupportLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"supportLineCell";
    
    YWSupportLineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YWSupportLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *supportLab = [[UILabel alloc] init];
    self.supportLab = supportLab;
    supportLab.font = FONT_14;
    supportLab.text = @"技术咨询";
    supportLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:supportLab];
    
    //状态按钮1
    UIButton *qqOnline = [[UIButton alloc] init];
    self.qqOnline = qqOnline;
    [qqOnline setImage:[UIImage imageNamed:@"fuwu_qq"] forState:UIControlStateNormal];
    [qqOnline addTarget:self action:@selector(qqBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.qqOnline];
    
    //状态按钮2
    UIButton *chatOnline = [[UIButton alloc] init];
    self.chatOnline = chatOnline;
    [chatOnline setImage:[UIImage imageNamed:@"fuwu_weixin"] forState:UIControlStateNormal];
    [chatOnline addTarget:self action:@selector(chatBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.chatOnline];
    
    //状态按钮3
    UIButton *msgOnline = [[UIButton alloc] init];
    self.msgOnline = msgOnline;
    [msgOnline setImage:[UIImage imageNamed:@"fuwu_youjian"] forState:UIControlStateNormal];
    [msgOnline addTarget:self action:@selector(msgBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.msgOnline];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    self.lineView.backgroundColor = COLOR_Line;
    self.lineView.alpha = 0.5;
    [self.contentView addSubview:self.lineView];
    
    
    //设置frame
    [self.supportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(18);
        make.height.mas_equalTo(25);
    }];
    
    
    [self.qqOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.supportLab.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.chatOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.qqOnline.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        
    }];
    
    [self.msgOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.chatOnline.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];

}
/**qq*/
- (void)qqBtnDidClick
{
    if (self.didTapQQBtn) {
        self.didTapQQBtn();
    }
    
}
/**微信*/
- (void)chatBtnDidClick
{
    
    if (self.didTapWeChatBtn) {
        self.didTapWeChatBtn();
    }
    
}

/**短信*/
- (void)msgBtnDidClick
{
    if (self.didTapMsgBtn) {
        self.didTapMsgBtn();
    }
    
}

- (void)setOnlineInfo:(YWOnlineInfo *)onlineInfo
{
    
    _onlineInfo = onlineInfo;
    
    self.supportLab.text = onlineInfo.specialty;
    
    
}
@end

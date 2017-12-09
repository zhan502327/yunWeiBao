//
//  YWSupportLineCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWOnlineInfo;
@interface YWSupportLineCell : UITableViewCell


/**1类别按钮*/
@property (nonatomic, weak) UIButton *qqOnline;
/**2类别按钮*/
@property (nonatomic, weak) UIButton *chatOnline;
/**3类别按钮*/
@property (nonatomic, weak) UIButton *msgOnline;
/**类别名*/
@property (nonatomic, weak) UILabel *supportLab;

/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;

/**qq*/
@property (copy, nonatomic) void (^didTapQQBtn)();
/**微信*/
@property (copy, nonatomic) void (^didTapWeChatBtn)();
/**短信*/
@property (copy, nonatomic) void (^didTapMsgBtn)();


/**订单列表模型*/
@property (nonatomic, strong) YWOnlineInfo *onlineInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

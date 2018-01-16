//
//  YWWarningEventController.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWWarningEventController : UITableViewController

@property (nonatomic, copy) void(^kNotificationOneCountBlock)(NSInteger count);

@end

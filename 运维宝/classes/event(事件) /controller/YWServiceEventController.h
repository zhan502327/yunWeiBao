//
//  YWServiceEventController.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWServiceEventController : UITableViewController
@property (nonatomic, copy) void(^kNotificationThreeCountBlock)(NSInteger count);


@end

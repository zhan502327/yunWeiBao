//
//  YWOperationEventController.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWEventModel.h"

@interface YWOperationEventController : UITableViewController

@property (nonatomic, copy) void(^kNotificationTwoCountBlock)(NSInteger count);

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *operationEvents;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;

/**预警事件*/
//@property (nonatomic, strong) YWEventModel *eventModel;

/**自动刷新一次*/
- (void)autoRefresh;
@end

//
//  DBNotificationModel.h
//  FMDB_Test
//
//  Created by zhang shuai on 2018/1/14.
//  Copyright © 2018年 zhandb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBNotificationModel : NSObject

//通知id
@property (nonatomic, copy) NSString *notificationID;

//是否被查看 默认为NO
@property (nonatomic, copy) NSString *isLooked;


@end

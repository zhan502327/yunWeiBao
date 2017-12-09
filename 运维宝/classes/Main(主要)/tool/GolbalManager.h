//  LMNavController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWUser;

@interface GolbalManager : NSObject<NSMutableCopying>

//是否登录
@property (nonatomic,assign)BOOL isLogin;

@property (nonatomic,strong) YWUser *logUser;

//定位的城市
@property (nonatomic,copy) NSString *locCity;
@property (nonatomic,assign)double lat;
@property (nonatomic,assign)double lon;


+ (GolbalManager*)sharedManager;

@end

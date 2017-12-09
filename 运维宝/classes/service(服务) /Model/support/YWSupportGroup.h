//
//  YWSupportGroup.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YWEmployeeInfo,YWBrandInfo;


@interface YWSupportGroup : NSObject


/**设备图纸*/
@property (nonatomic, strong) YWEmployeeInfo *employee;
/**公共文档*/
@property (nonatomic, strong) YWBrandInfo *brand;
/**设备文档*/
@property (nonatomic, strong) NSArray *online;


@end

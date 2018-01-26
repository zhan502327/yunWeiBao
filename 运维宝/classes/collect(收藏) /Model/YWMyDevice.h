//
//  YWMyDevice.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/2.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMyDevice : NSObject

/**状态*/

@property (nonatomic, copy) NSString *status;
//@property (nonatomic, assign)  NSInteger  status;
/** 名称 */
@property (nonatomic, copy) NSString   *name;
/**电站ID*/
@property (nonatomic, copy) NSString   *station;
/** 名称 */
@property (nonatomic, copy) NSString   *s_id;
/**电站ID*/
@property (nonatomic, copy) NSString   *a_id;

@end

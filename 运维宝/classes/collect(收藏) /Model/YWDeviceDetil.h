//
//  YWDeviceDetil.h
//  运维宝
//
//  Created by 斌  on 2017/11/6.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWDeviceDetil : NSObject

/**状态*/
@property (nonatomic, copy) NSString   *class_name;
/** 名称 */
@property (nonatomic, copy) NSString   *danger;
/**电站ID*/
@property (nonatomic, copy) NSString   *attention;
/** 名称 */
@property (nonatomic, copy) NSString   *normal;
/**电站ID*/
@property (nonatomic, copy) NSString   *offline;
/**电站ID*/
@property (nonatomic, copy) NSString   *class_code;

@end

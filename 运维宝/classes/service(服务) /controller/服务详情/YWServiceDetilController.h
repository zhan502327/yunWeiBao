//
//  YWServiceDetilController.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWSercice;

@interface YWServiceDetilController : UIViewController
/** 设备模型 */
@property (nonatomic, strong) YWSercice *deviceSercice;
/**设备ID*/
@property (nonatomic, copy) NSString   *a_id;

@end

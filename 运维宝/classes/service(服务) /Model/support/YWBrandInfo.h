//
//  YWBrandInfo.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWBrandCoreOne,YWBrandCoreTwo,YWBrandDetil;
@interface YWBrandInfo : NSObject


/**状态*/
@property (nonatomic, copy) NSString  *hotline;
/**设备图纸*/
@property (nonatomic, strong) YWBrandCoreOne *core1;
/**公共文档*/
@property (nonatomic, strong) YWBrandDetil *brand;
/**设备文档*/
@property (nonatomic, strong) YWBrandCoreTwo *core2;

@end

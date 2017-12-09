//
//  LMNavController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extend)


/**
 *  返回任意对象的字符串式的内存地址
 */
-(NSString *)address;


/**
 *  调用方法
 */
-(void)callSelectorWithSelString:(NSString *)selString paramObj:(id)paramObj;


@end

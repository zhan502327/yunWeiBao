//
//  XLSlideSwitchDelegate.h
//  实体联盟
//
//  Created by 贾斌 on 2017/7/7.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLSlideSwitchDelegate <NSObject>

@optional
/**
 * 切换位置后的代理方法
 */
- (void)slideSwitchDidselectAtIndex:(NSInteger)index;

@end

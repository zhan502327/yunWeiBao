//
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//  根据上一次的位置和偏移量判断当前页码

#import <UIKit/UIKit.h>

@interface UICollectionViewController (SCCurrentPage)


/**
 *  根据上一次的位置和滚动偏移量计算滚动停止后的页码
 *
 *  @param pageNumber   上一次的页码
 *  @param count        总页数
 *  @param offset       偏移量
 *
 *  @return 所滚到的页码
 */
- (NSUInteger)setCurrentPageNumberWithLastPageNumber:(NSUInteger)pageNumber
                                          totalCount:(NSUInteger)count
                                              offset:(CGFloat)offset;

@end 

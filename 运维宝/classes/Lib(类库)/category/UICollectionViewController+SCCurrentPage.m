//
//  UICollectionViewController+SCCurrentPage.m
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "UICollectionViewController+SCCurrentPage.h"

@implementation UICollectionViewController (SCCurrentPage)

- (NSUInteger)setCurrentPageNumberWithLastPageNumber:(NSUInteger)pageNumber
                                          totalCount:(NSUInteger)count
                                              offset:(CGFloat)offset {
    
    NSUInteger currentPageNumber = pageNumber;

    for (NSUInteger i = 0; i < count; i++) {
        if (offset == self.view.width * i) {
            currentPageNumber = i;
        }
    }
    
    return currentPageNumber;
}

@end 

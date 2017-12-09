//
//  XLSlideSegment.h
//  实体联盟
//
//  Created by 贾斌 on 2017/7/7.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLSlideSegmentDelegate <NSObject>

- (void)slideSegmentDidSelectedAtIndex:(NSInteger)index;

@end

@interface XLSlideSegmented : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIColor *itemNormalColor;

@property (nonatomic, strong) UIColor *itemSelectedColor;

@property (nonatomic, assign) BOOL showTitlesInNavBar;

@property (nonatomic, assign) BOOL hideShadow;

@property (nonatomic, weak) id<XLSlideSegmentDelegate>delegate;

@property (nonatomic, assign) CGFloat progress;

//忽略动画
@property (nonatomic, assign) BOOL ignoreAnimation;

@end

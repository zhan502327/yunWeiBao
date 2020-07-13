//
//  DBLineView.h
//  运维宝
//
//  Created by zhandb on 2020/7/9.
//  Copyright © 2020 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWChartGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBLineView : UIView


/// x轴坐标
@property (nonatomic, strong) NSArray *xLabelTitleArray;





@property (nonatomic,strong) YWChartGroup *chartData;



@end

NS_ASSUME_NONNULL_END

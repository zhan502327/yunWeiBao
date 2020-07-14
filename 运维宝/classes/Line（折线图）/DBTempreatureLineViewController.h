//
//  DBTempreatureLineViewController.h
//  运维宝
//
//  Created by zhandb on 2020/7/9.
//  Copyright © 2020 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface DBTempreatureLineViewController : UIViewController



/** 我的电站*/
@property (nonatomic, copy) NSString *a_id;

@property (nonatomic) NSInteger selectIndex;

@property (nonatomic,retain) NSMutableDictionary *dataserver;
@property (nonatomic,retain) NSMutableArray *temperature;


@property (nonatomic, retain) UIActivityIndicatorView    *loading;
@property (nonatomic, retain) UIView *bg;




@property (nonatomic) NSInteger pick0compentfocusIndex;
@property (nonatomic) NSInteger pick1compentfocusIndex;
@property (nonatomic) NSInteger pick2compentfocusIndex;
@property (nonatomic) NSInteger pick3compentfocusIndex;


-(void)setTimeButtonInfo:(UIButton *)cell;
-(NSString*)getTimeButtonBG:(NSString *)title;


@end

NS_ASSUME_NONNULL_END

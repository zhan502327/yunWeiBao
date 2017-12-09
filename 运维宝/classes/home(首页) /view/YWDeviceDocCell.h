//
//  YWDeviceDocCell.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWDeviceDocs;
@interface YWDeviceDocCell : UITableViewCell


/**1类别按钮*/
@property (nonatomic, weak) UILabel *titleLab;
/**2类别按钮*/
@property (nonatomic, weak) UILabel *detilLab;

/** 分隔线 */
@property (nonatomic,weak) UIView *lineView;

/**设备文档*/
@property (nonatomic, strong) YWDeviceDocs *deviceDoc;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

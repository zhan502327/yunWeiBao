//
//  YWSerch.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/12.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWSerch : NSObject


/**状态*/
@property (nonatomic,assign)     int   status;
/** 名称 */
@property (nonatomic, copy) NSString   *assets_name;
/**电站ID*/
@property (nonatomic, copy) NSString   *assets_id;


@end

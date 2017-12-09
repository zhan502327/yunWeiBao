//
//  YWDeviceInfo.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWDeviceInfo : NSObject



/**设备名称*/
@property (nonatomic, copy) NSString   *assets_name;
/**设备类型 */
@property (nonatomic, copy) NSString   *class_name;
/**设备型号*/
@property (nonatomic, copy) NSString   *assets_model;
/**设备规格*/
@property (nonatomic, copy) NSString   *specification_name;
/**制造日期 */
@property (nonatomic, copy) NSString   *core_date_1;
/**出厂编号*/
@property (nonatomic, copy) NSString   *assets_number;
/**制造商*/
@property (nonatomic, copy) NSString   *brand_name;


/**核心组件 */
@property (nonatomic, copy) NSString   *core_name_1;
/**组件型号*/
@property (nonatomic, copy) NSString   *core_model_1;
/**组件规格*/
@property (nonatomic, copy) NSString   *core_specifications_1;
/**出厂编号*/
@property (nonatomic, copy) NSString   *core_id_1;
/**制造商*/
@property (nonatomic, copy) NSString   *com_1;


/**核心组件 */
@property (nonatomic, copy) NSString   *core_name_2;
/**组件型号*/
@property (nonatomic, copy) NSString   *core_model_2;
/**组件规格*/
@property (nonatomic, copy) NSString   *core_specifications_2;
/**出厂编号*/
@property (nonatomic, copy) NSString   *core_id_2;
/**制造商*/
@property (nonatomic, copy) NSString   *com_2;


@end

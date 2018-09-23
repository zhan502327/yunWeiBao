//
//  YWMyStations.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/2.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMyStations : NSObject

/**状态*/
@property (nonatomic, copy) NSString *status;
/** 名称 */
@property (nonatomic, copy) NSString *station_name;
/**电站ID*/
@property (nonatomic, copy) NSString *station_id;
/** 名称 */
@property (nonatomic, copy) NSString *s_id;
/**电站ID*/
@property (nonatomic, copy) NSString *a_id;
/**是否收藏 */
@property (nonatomic, assign) BOOL  is_collection;
/** 名称 */
@property (nonatomic, copy) NSString *assets_name;


//Address = "\U6cb3\U5357\U7701\U90d1\U5dde\U5e02";
//Latitude = "34.74642300000000";
//Longitude = "113.60150300000000";
//"Responsible_class_code_1" = "<null>";
//"Responsible_class_code_2" = "<null>";
//"Responsible_class_code_3" = "<null>";
//"Responsible_employee_id_1" = 0;
//"Responsible_employee_id_2" = 0;
//"Responsible_employee_id_3" = 0;
//"Temperature_difference_attention" = 5;
//"Temperature_difference_danger" = 10;
//"Temperature_difference_enable" = N;
//"ambient_temperature_attention" = "<null>";
//"ambient_temperature_danger" = "<null>";
//"ambient_temperature_enable" = N;
//city = "\U90d1\U5dde";
//"customer_id" = 2;
//"department_0" = 55;
//"department_1" = 62;
//"department_2" = 0;
//"department_id" = 62;
//"dynamic_temperature_attention" = 35;
//"dynamic_temperature_danger" = 65;
//"dynamic_temperature_enable" = N;
//"dynamic_temperature_m" = "1.20";
//"dynamic_temperature_n" = ".50";
//"heweather_id" = CN101180101;
//"last_date" = "2018-01-25 00:31:29.907";
//"last_ip" = "140.243.172.58";
//"last_user" = 18060968906;
//province = "\U6cb3\U5357";
//"station_id" = 40;
//"station_name" = "110KV\U4e2d\U539f\U53d8\U7535\U7ad9";
//"temperature_attention" = "<null>";
//"temperature_danger" = "<null>";
//"write_date" = "2017-07-29 15:14:52.157";
//"write_ip" = "117.28.100.170";
//"write_user" = 13600976198;

@end

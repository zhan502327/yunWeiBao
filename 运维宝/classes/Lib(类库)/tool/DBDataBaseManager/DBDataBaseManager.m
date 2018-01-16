//
//  DBDataBaseManager.m
//  FMDB_Test
//
//  Created by zhang shuai on 2018/1/14.
//  Copyright © 2018年 zhandb. All rights reserved.
//

#import "DBDataBaseManager.h"



static DBDataBaseManager *manager = nil;

@implementation DBDataBaseManager

+ (DBDataBaseManager *)shareDataBaseManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[DBDataBaseManager alloc] init];
        
        [manager createDataBase];
        [manager createTableWithTableName:kNotificationOne];
        [manager createTableWithTableName:kNotificationTwo];
        [manager createTableWithTableName:kNotificationThree];

    });
    
    return manager;
}

#pragma mark -- 创建数据库
- (void)createDataBase{
    

    //获取沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filePath = [doc stringByAppendingPathComponent:@"notificationModel.sqlite"];
    
    //创建数据库
    self.db = [FMDatabase databaseWithPath:filePath];
    
    NSLog(@"filePath     %@",filePath);
    
}


#pragma mark -- 创建表
- (void)createTableWithTableName:(NSString *)tableName{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (notificationID varchar(256) PRIMARY KEY NOT NULL, isLooked varchar(256) NOT NULL, alert_id varchar(256), explain varchar(256), device_id varchar(256), station varchar(256), alert_type_name varchar(256), happen_time varchar(256), a_id varchar(256), asset varchar(256))",tableName];

        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            NSLog(@"创建 %@ 成功",tableName);
        }else{
            NSLog(@"创建 %@ 失败",tableName);
        }
        [self.db close];
    }else{
        NSLog(@"创建表 - 数据库打开失败");
    }
}

#pragma mark -- 增
- (void)insertNotificationModel:(YWEventModel *)model tableName:(NSString *)tableName{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (notificationID, isLooked, alert_id, explain, device_id, station, alert_type_name, happen_time, a_id, asset) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",tableName ,model.notificationID, model.isLooked, model.alert_id, model.explain, model.device_id, model.station, model.alert_type_name, model.happen_time, model.a_id, model.asset];

        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            NSLog(@"插入数据成功");
        }else{
            NSLog(@"插入数据失败");
            [self updateNotificationModel:model tableName:tableName];
        }
        [self.db class];
    }else{
        NSLog(@"插入数据 - 数据库打开失败");
    }
}
#pragma mark -- 删
- (void)deleteNotificationModel:(YWEventModel *)model tableName:(NSString *)tableName{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE notificationID = %@",tableName , model.notificationID];
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            NSLog(@"删除数据成功");
        }else{
            NSLog(@"删除数据失败");
        }
    }else{
        NSLog(@"删除数据 - 数据库打开失败");
    }
}



#pragma mark -- 改
- (void)updateNotificationModel:(YWEventModel *)model tableName:(NSString *)tableName{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET alert_id = '%@', explain = '%@', device_id = '%@', station = '%@', alert_type_name = '%@', happen_time = '%@', a_id = '%@', asset = '%@' WHERE notificationID = '%@'",tableName , model.alert_id, model.explain, model.device_id, model.station, model.alert_type_name, model.happen_time, model.a_id, model.asset, model.notificationID];
        
        BOOL result = [self.db executeUpdate:sql];
        
        if (result) {
            NSLog(@"修改数据成功");
        }else{
            NSLog(@"修改数据失败");
        }
        
    }else{
        NSLog(@"修改数据 - 数据库打开失败");
    }
}

#pragma mark -- 点击cell 修改为已读
- (void)updateNotificationModel:(YWEventModel *)model tableName:(NSString *)tableName WithIsLooked:(NSString *)isLooked{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET isLooked = '%@' WHERE notificationID = '%@'",tableName, isLooked, model.notificationID];
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            NSLog(@"修改数据成功");
        }else{
            NSLog(@"修改数据失败");
        }
    }else{
        NSLog(@"修改数据 - 数据库打开失败");
    }
}


#pragma mark -- 查询全部数据
- (NSArray *)queryAllNotificationModelWithtableName:(NSString *)tableName{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
        FMResultSet *set = [self.db executeQuery:sql];
        while ([set next]) {
            NSString *notificationID = [set stringForColumn:@"notificationID"];
            NSString *isLooked = [set stringForColumn:@"isLooked"];
            NSString *alert_id = [set stringForColumn:@"alert_id"];
            NSString *explain = [set stringForColumn:@"explain"];
            NSString *device_id = [set stringForColumn:@"device_id"];
            NSString *station = [set stringForColumn:@"station"];
            NSString *alert_type_name = [set stringForColumn:@"alert_type_name"];
            NSString *happen_time = [set stringForColumn:@"happen_time"];
            NSString *a_id = [set stringForColumn:@"a_id"];
            NSString *asset = [set stringForColumn:@"asset"];
     
            YWEventModel *model = [[YWEventModel alloc] init];
            model.notificationID = notificationID;
            model.isLooked = isLooked;
            model.alert_id = alert_id;
            model.explain = explain;
            model.device_id = device_id;
            model.station = station;
            model.alert_type_name = alert_type_name;
            model.happen_time = happen_time;
            model.a_id = a_id;
            model.asset = asset;
            [resultArray addObject:model];
        }
    }else{
        NSLog(@"查询数据 - 数据库打开失败");
    }
    return resultArray;
}

#pragma mark -- 查询指定的数据
- (NSArray *)queryIsLookedCountWithTableName:(NSString *)tableName{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE isLooked = '%@'",tableName ,@"0"];
        FMResultSet *set = [self.db executeQuery:sql];
        while ([set next]) {
            NSString *notificationID = [set stringForColumn:@"notificationID"];
            NSString *isLooked = [set stringForColumn:@"isLooked"];
            NSString *alert_id = [set stringForColumn:@"alert_id"];
            NSString *explain = [set stringForColumn:@"explain"];
            NSString *device_id = [set stringForColumn:@"device_id"];
            NSString *station = [set stringForColumn:@"station"];
            NSString *alert_type_name = [set stringForColumn:@"alert_type_name"];
            NSString *happen_time = [set stringForColumn:@"happen_time"];
            NSString *a_id = [set stringForColumn:@"a_id"];
            NSString *asset = [set stringForColumn:@"asset"];
            
            YWEventModel *model = [[YWEventModel alloc] init];
            model.notificationID = notificationID;
            model.isLooked = isLooked;
            model.alert_id = alert_id;
            model.explain = explain;
            model.device_id = device_id;
            model.station = station;
            model.alert_type_name = alert_type_name;
            model.happen_time = happen_time;
            model.a_id = a_id;
            model.asset = asset;
            
            
            if (model.notificationID.length > 0) {
                [array addObject:model];
            }
            
        }
    }else{
        NSLog(@"查询指定数据 - 数据库打开失败");
    }
    return array;
}
#pragma mark -- 删除数据表
- (void)deleteTableWithtableName:(NSString *)tableName{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            NSLog(@"删除数据表成功");
        }else{
            NSLog(@"删除数据表失败");
        }
    }else{
        NSLog(@"查询数据 - 数据库打开失败");
    }
}

@end

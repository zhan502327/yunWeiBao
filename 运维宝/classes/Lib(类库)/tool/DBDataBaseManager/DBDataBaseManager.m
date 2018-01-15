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
//        [manager createTableWithTableName:kNotificationTwo];
//        [manager createTableWithTableName:kNotificationThree];

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
//        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (notificationID TEXT PRIMARY KEY NOT NULL, isLooked TEXT NOT NULL, alert_id TEXT, explain TEXT, device_id TEXT, station TEXT, alert_type_name TEXT, happen_time TEXT, a_id TEXT, asset TEXT)",tableName];
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

////        BOOL result1 = [self.db executeUpdate:@"UPDATE ? SET isLooked = ? WHERE notificationID = ?",tableName , model.isLooked, model.notificationID];
//        BOOL result1 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"isLooked" value:model.isLooked where:model.notificationID]];
//
//
////        BOOL result2 = [self.db executeUpdate:@"UPDATE ? SET alert_id = ? WHERE notificationID = ?",tableName , model.alert_id, model.notificationID];
//        BOOL result2 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"alert_id" value:model.alert_id where:model.notificationID]];
//
////        BOOL result3 = [self.db executeUpdate:@"UPDATE ? SET explain = ? WHERE notificationID = ?",tableName , model.explain, model.notificationID];
//        BOOL result3 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"explain" value:model.explain where:model.notificationID]];
//
////        BOOL result4 = [self.db executeUpdate:@"UPDATE ? SET device_id = ? WHERE notificationID = ?",tableName , model.device_id, model.notificationID];
//        BOOL result4 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"device_id" value:model.device_id where:model.notificationID]];
//
////        BOOL result5 = [self.db executeUpdate:@"UPDATE ? SET station = ? WHERE notificationID = ?",tableName , model.station, model.notificationID];
//        BOOL result5 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"station" value:model.station where:model.notificationID]];
//
////        BOOL result6 = [self.db executeUpdate:@"UPDATE ? SET alert_type_name = ? WHERE notificationID = ?",tableName , model.alert_type_name, model.notificationID];
//        BOOL result6 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"alert_type_name" value:model.alert_type_name where:model.notificationID]];
//
////        BOOL result7 = [self.db executeUpdate:@"UPDATE ? SET happen_time = ? WHERE notificationID = ?",tableName , model.happen_time, model.notificationID];
//        BOOL result7 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"happen_time" value:model.happen_time where:model.notificationID]];
//
////        BOOL result8 = [self.db executeUpdate:@"UPDATE ? SET a_id = ? WHERE notificationID = ?",tableName , model.a_id, model.notificationID];
//        BOOL result8 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"a_id" value:model.a_id where:model.notificationID]];
//
////        BOOL result9 = [self.db executeUpdate:@"UPDATE ? SET asset = ? WHERE notificationID = ?",tableName , model.asset, model.notificationID];
//        BOOL result9 = [self.db executeUpdate:[self upDateSqliteWithTableName:tableName key:@"asset" value:model.asset where:model.notificationID]];

        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET alert_id = '%@', explain = '%@', device_id = '%@', station = '%@', alert_type_name = '%@', happen_time = '%@', a_id = '%@', asset = '%@' WHERE notificationID = '%@'",tableName , model.alert_id, model.explain, model.device_id, model.station, model.alert_type_name, model.happen_time, model.a_id, model.asset, model.notificationID];
        
        BOOL result = [self.db executeUpdate:sql];

//        if (result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9) {
//            NSLog(@"修改数据成功");
//        }else{
//            NSLog(@"修改数据失败");
//        }
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

- (NSString *)upDateSqliteWithTableName:(NSString *)tableName key:(NSString *)key value:(NSString *)value where:(NSString *)whereStr{
    NSString *str = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %@ WHERE notificationID = %@",tableName , key, value, whereStr];
    return str;
}


#pragma mark -- 查
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

//
//  YWDeviceDocs.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWDeviceDocs : NSObject

/**高压柜*/
@property (nonatomic, copy) NSString   *write_date;
/** 名称 */
@property (nonatomic, copy) NSString   *document_name;
/**电站ID*/
@property (nonatomic, copy) NSString   *document_id;
/**高压柜*/
@property (nonatomic, copy) NSString   *file_id;
/** 名称 */
@property (nonatomic, copy) NSString   *file_path;

@end

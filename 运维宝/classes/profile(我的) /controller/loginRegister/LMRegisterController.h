//
//  LMRegisterController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/7/9.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMRegisterController : UIViewController

typedef enum _VcType
{
    registerType =0,
    findType =1
}VcType;


@property (nonatomic,assign) VcType type;


@end

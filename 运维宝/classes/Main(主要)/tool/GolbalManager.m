//  LMNavController.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "GolbalManager.h"
@implementation GolbalManager

static GolbalManager *shareManager = nil;

#pragma mark - 获取单例
+ (GolbalManager*)sharedManager{
    if (!shareManager) {
        @synchronized(self)
        {
            
            if (!shareManager)
            {
                shareManager = [[GolbalManager alloc]init];
            }
        }
    }
    return shareManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if (shareManager == nil)
    {
        @synchronized(self)
        {
            if (shareManager == nil)
            {
                shareManager = [super allocWithZone:zone];
            }
        }
    }
    return shareManager;
}

- (id)init
{
    if (self = [super init])
    {
        [shareManager initsub];
    }
    return self;
}

-(void)initsub
{

}

-(void)dealloc
{
   
}

@end

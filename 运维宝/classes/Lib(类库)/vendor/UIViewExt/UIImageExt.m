//
//  UIImageExt.m
//  jiuquan
//
//  Created by geng on 14-11-27.
//  Copyright (c) 2014年 geng. All rights reserved.
//

#import "UIImageExt.h"

@implementation UIImage(imageSelect)
+(UIImage*)imagefileNamed:(NSString *)name
{
    name=[NSString stringWithFormat:@"Custompic.bundle/%@",name];
    NSString* extername=[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:name];
    BOOL isexist=[[NSFileManager defaultManager]fileExistsAtPath:extername];
    if (isexist) {
        return [UIImage imageWithContentsOfFile:extername];
    }
    //    UIImage* image=[UIImage imageWithContentsOfFile:extername];
    UIImage* image=nil;
    if(image==nil&& [UIScreen mainScreen].scale==1 )
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@2x.png"]];
    }
    if(image==nil&& [UIScreen mainScreen].scale==2 )
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@2x.png"]];
    }
    if (image==nil&[UIScreen mainScreen].scale==3) {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@3x.png"]];
    }
    if(image==nil&& [UIScreen mainScreen].scale==1)
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@".jpg"]];
    }
    if(image==nil&& [UIScreen mainScreen].scale==2)
    {
        
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@2x.jpg"]];
    }
    if(image==nil&[UIScreen mainScreen].scale==3)
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@3x.jpg"]];
    }
    
#ifdef DEBUG
    if(image==nil)
    {
        //        NSLog(@"image does't exist at path:%@",extername);
    }
#endif
    
    return image;
}



+(UIImage*)imagefilehaveNamed:(NSString *)name
{
    NSString* extername=[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Custompic.bundle/%@",name]];
        BOOL isexist=[[NSFileManager defaultManager]fileExistsAtPath:extername];
        if (isexist) {
            return [UIImage imageWithContentsOfFile:extername];
        }
    UIImage* image=[UIImage imageWithContentsOfFile:extername];
 
    
        if(image==nil&& [UIScreen mainScreen].scale==1)
        {
            image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@2x.png"]];
        }
        if(image==nil&& [UIScreen mainScreen].scale==2)
        {
            image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@2x.png"]];
        }
        if(image==nil&[UIScreen mainScreen].scale==3)
        {
            image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@3x.png"]];
        }
    
#ifdef DEBUG
    if(image==nil)
    {
        //        NSLog(@"image does't exist at path:%@",extername);
    }
#endif
    
    return image;
}
@end

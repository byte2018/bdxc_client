//
//  UIImage+WZ.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 王震. All rights reserved.
//

#import "UIImage+WZ.h"
#import "Common.h"

@implementation UIImage (WZ)

#pragma mark 适配iphone5
+(UIImage *)apaterMyImage:(NSString *)imageName
{
    
    NSString *iphoneImageName = imageName;
    
    
    //进行iphone5屏幕适配
    if(IPHONE5){
        //获取文件扩展名
        NSString *ext = [imageName pathExtension];
        // 获得去除扩展名的图片文件名
        NSString *removeExtImageName = [imageName stringByDeletingPathExtension];
        //拼接适配iphone5的图片
        iphoneImageName = [removeExtImageName stringByAppendingString:@"@2x"];
        
        iphoneImageName = [iphoneImageName stringByAppendingPathExtension:ext];
        //NSLog(@"%@", iphoneImageName);
    }
    
    UIImage *image = [UIImage imageNamed: iphoneImageName];
    
    
    return image;

}
#pragma mark 对图片进行拉伸
+(UIImage *)tileMyImage:(NSString *)imageName
{
    //默认Cell背景
    UIImage *image = [UIImage apaterMyImage:imageName];
    // 左端盖宽度
    NSInteger leftCapWidth = image.size.width * 0.5f;
    // 顶端盖高度
    NSInteger topCapHeight = image.size.height * 0.5f;
    // 重新赋值
    image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    return image;

}


@end

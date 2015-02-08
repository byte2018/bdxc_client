//
//  UIImage+WZ.h
//  保定小吃
//
//  Created by javadonkey on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WZ)
//对iphone图片进行适配
+(UIImage *)apaterMyImage:(NSString *)imageName;
//对背景图片进行拉伸
+(UIImage *)tileMyImage:(NSString *)imageName;

@end

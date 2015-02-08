//
//  WZImageTool.h
//  保定小吃
//
//  Created by 王震 on 14-8-5.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZImageTool : NSObject

//等比率缩放
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//自定长宽
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end

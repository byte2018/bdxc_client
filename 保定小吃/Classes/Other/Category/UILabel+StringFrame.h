//
//  UILabel+StringFrame.h
//  保定小吃
//
//  Created by 王震 on 14-9-5.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
// iOS7中出现了新的方法计算UILabel中根据给定的Font以及str计算UILabel的frameSize的方法

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size;

@end

//
//  NSString+WZURLEncoding.h
//  保定小吃
//
//  Created by 王震 on 14-7-31.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WZURLEncoding)
//编码URL
-(NSString *)URLEncodedString;
//解码URL
-(NSString *)URLDecodedString;
@end

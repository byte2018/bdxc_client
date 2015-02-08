//
//  NSString+WZURLEncoding.m
//  保定小吃
//
//  Created by 王震 on 14-7-31.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "NSString+WZURLEncoding.h"

@implementation NSString (WZURLEncoding)

#pragma  mark 编码URL
-(NSString *)URLEncodedString
{
    NSString *url = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (CFStringRef)self,
        NULL, CFSTR("+$, #[]"),
        kCFStringEncodingUTF8));
    return url;
}


#pragma  mark 解码URL
-(NSString *)URLDecodedString
{
    NSString *url = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
        (CFStringRef)self,
        CFSTR(""),
        kCFStringEncodingUTF8));
    
    return url;
}

@end

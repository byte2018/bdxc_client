//
//  WZHTTPTool.h
//  保定小吃
//
//  Created by 王震 on 14-7-31.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//   访问restful接口工具类

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

@protocol MyReloadDataDelegate

-(void)myReloadData: (NSDictionary *)resDict;

@end

@interface WZHTTPTool : NSObject
{
    id<MyReloadDataDelegate> deleage;
    MKNetworkEngine *_engine; //设为共有变量，防止程序崩溃
    
}

@property(assign,nonatomic)id<MyReloadDataDelegate> delegate;

//获得get请求数据
-(NSDictionary *)httpGetJsonSynchronizedRequest:(NSString *)httpUrl params:(NSDictionary *)params;


-(void)uploadImage:(NSString *)fullPath myPath:(NSString *) myPath hostName:(NSString *) hostName param: (NSMutableDictionary *)param myFileParam:(NSString *)myFileParam fileType:(NSString *)fileType;

-(void)httpPostJsonRequest:(NSString *) hostName myPath:(NSString *) myPath param: (NSMutableDictionary *)param ;

@end

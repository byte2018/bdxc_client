//
//  WZPublishShow.h
//  保定小吃
//
//  Created by 王震 on 14-8-11.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  小吃图片展示模型

#import <Foundation/Foundation.h>

@interface WZPublishShow : NSObject

@property(nonatomic, copy) NSString *userName;//用户名称

@property(nonatomic, copy) NSString *userIcon;//用户头像图片

@property(nonatomic, copy) NSString *pulishDate;//发布时间

@property(nonatomic, copy) NSString *textIntroduce;//文字介绍

@property(nonatomic, strong) NSMutableArray *foodIcons;//用户上传图片

@property(nonatomic, assign)NSInteger *supportNum;//点赞数
@property(nonatomic, assign)NSInteger *commentNum; //评论数
@property(nonatomic, assign)NSInteger *relayNum;//转发数



@end

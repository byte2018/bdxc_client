//
//  WZDock.h
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZDock;

@protocol DockDelegate <NSObject>

@optional
-(void)dock:(WZDock *)dock itemSelectedFrom:(int)from to:(int)to;

@end


@interface WZDock : UIView

// 代理
@property(nonatomic, assign) id<DockDelegate> delegate;
//添加标签项
-(void)addItemWithIcon:(NSString *)icon selected:(NSString *)selectedIcon title:(NSString *)title ;

@end

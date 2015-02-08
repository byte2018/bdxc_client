//
//  WZWorksStyleViewController.h
//  保定小吃
//
//  Created by 王震 on 14-9-13.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  展现作品发布形式

#import <UIKit/UIKit.h>
@protocol MySwitchViewDelegate

-(void)mySwitchView;

@end
@interface WZWorksStyleViewController : UIViewController
{
    id<MySwitchViewDelegate> deleage;
}

@property(assign,nonatomic)id<MySwitchViewDelegate> delegate;


@end

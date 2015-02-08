//
//  WZLoginViewController.h
//  保定小吃
//
//  Created by 王震 on 14-9-20.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MySwitchViewDelegate

-(void)mySwitchView;

@end


@interface WZLoginViewController : UIViewController
{
    id<MySwitchViewDelegate> deleage;
}

@property(assign,nonatomic)id<MySwitchViewDelegate> delegate;

@end

//
//  WZDockViewController.h
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZDock.h"

@interface WZDockViewController : UIViewController
{
    WZDock *_dock;
    
}

@property(nonatomic, readonly) UIViewController *selectedController;


@end

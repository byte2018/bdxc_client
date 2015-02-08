//
//  WZDockViewController.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//用于显示标签导航

#import "WZDockViewController.h"
#import "WZDock.h"
#import "UIImage+WZ.h"

#define KDockHeight 44 //定义dock的高度

@interface WZDockViewController () <DockDelegate>


@end

@implementation WZDockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
   
}

#pragma mark dock的代理方法
-(void)dock:(WZDock *)dock itemSelectedFrom:(int)from to:(int)to
{
    //NSLog(@"sdfsdfdfds");
    
    
    //如果超出标签范围，则方法自动退出
    if(to < 0 || to >= self.childViewControllers.count) return;
    
    //移除旧控制器的view
    UIViewController *oldView = self.childViewControllers[from];
    [oldView.view removeFromSuperview];
    
    //显示新的控制器view
    UIViewController *newView = self.childViewControllers[to];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - KDockHeight;
    
    newView.view.frame = CGRectMake(0, 0, width, height);
    
    
    [self.view addSubview:newView.view];
    
    _selectedController = newView;
   
   
    
}





@end

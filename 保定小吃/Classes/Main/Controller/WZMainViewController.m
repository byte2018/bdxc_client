//
//  WZMainViewController.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  选项开转换视图控制

#import "WZMainViewController.h"
#import "WZHomeTableViewController.h"
#import "WZCategoryTableViewController.h"
#import "WZPublishTableViewController.h"
#import "WZActivitiesTableViewController.h"
#import "WZUINavigationViewController.h"
#import "UIImage+WZ.h"
#import "WZUserTableViewController.h"


#define KDockHeight 44 //定义dock的高度

@interface WZMainViewController ()

@end

@implementation WZMainViewController
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
    
    //添加全部的子视图控件
    [self addAllChildViewController];
    
    //添加选项卡标签
    [self addDockItem];
}


#pragma  mark 添加全部的子视图控件
- (void)addAllChildViewController
{
    //默认展示页面
    WZHomeTableViewController *home = [[WZHomeTableViewController alloc] init];
    
    WZUINavigationViewController *homeNav = [[WZUINavigationViewController alloc] initWithRootViewController:home];
    
    [self addChildViewController:homeNav];
    
//    //类别展示
//    WZCategoryTableViewController *category = [[WZCategoryTableViewController alloc] init];
//    
//    
//    WZUINavigationViewController *categoryNav = [[WZUINavigationViewController alloc] initWithRootViewController:category];
//    [self addChildViewController:categoryNav];
    
    //作品发布
    WZPublishTableViewController *publish = [[WZPublishTableViewController alloc] init];
   
    WZUINavigationViewController *publishNav = [[WZUINavigationViewController alloc] initWithRootViewController:publish];
        
    [self addChildViewController:publishNav];
    
    
    
    
    //活动展示
    WZActivitiesTableViewController *activities = [[WZActivitiesTableViewController alloc] init];
    WZUINavigationViewController *activitiesNav = [[WZUINavigationViewController alloc] initWithRootViewController:activities];
    [self addChildViewController:activitiesNav];
    
    
    //用户设置展示
    WZUserTableViewController *user = [[WZUserTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    WZUINavigationViewController *userNav = [[WZUINavigationViewController alloc] initWithRootViewController:user];
    [self addChildViewController:userNav];
}



#pragma  mark 添加选项卡标签
-(void)addDockItem
{
    //初始化dock
    WZDock *dock = [[WZDock alloc] init];
    dock.backgroundColor = [UIColor colorWithPatternImage:[UIImage apaterMyImage:@"tabbar_background.png"]];
    
    //设置dock的位置和大小
    dock.frame = CGRectMake(0, self.view.frame.size.height  - KDockHeight, self.view.frame.size.width, KDockHeight);
        //    [dock addItemWithIcon:@"tabbar_more.png" selected:@"tabbar_more_selected.png" title:@"更多"];
    //设置代理对象
    dock.delegate = self;
    [self.view addSubview:dock];
    [dock addItemWithIcon:@"tab_icon_recommend_normal.png" selected:@"tab_icon_recommend_hl.png" title:@"首页"];
//    [dock addItemWithIcon:@"tab_icon_catalogs_normal.png" selected:@"tab_icon_catalogs_hl.png" title:@"分类"];
    [dock addItemWithIcon:@"tab_icon_dishes_normal.png" selected:@"tab_icon_dishes_hl.png" title:@"作品"];
    [dock addItemWithIcon:@"tab_icon_events_normal.png" selected:@"tab_icon_events_hl.png" title:@"菜谱"];
    [dock addItemWithIcon:@"tab_icon_user_normal.png" selected:@"tab_icon_user_hl.png" title:@"用户"];

    _dock = dock;
    
}





@end

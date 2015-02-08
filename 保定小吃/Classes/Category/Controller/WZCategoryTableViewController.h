//
//  WZCategoryTableViewController.h
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  用于云标签搜索

#import <UIKit/UIKit.h>
#import "WWTagsCloudView.h"

@interface WZCategoryTableViewController : UIViewController <WWTagsCloudViewDelegate>


@property (strong, nonatomic) WWTagsCloudView* tagCloud;
@property (strong, nonatomic) NSArray* tags;


@end

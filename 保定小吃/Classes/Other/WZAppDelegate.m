//
//  WZAppDelegate.m
//  保定小吃
//
//  Created by javadonkey on 14-7-28.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZAppDelegate.h"
#import "WZNewFeatureViewController.h"
#import "WZMainViewController.h"

@implementation WZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *key = (NSString *) kCFBundleVersionKey;
    //从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //从沙盒中取得上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if([version isEqualToString:saveVersion]){//不是第一次运行，或者版本不一致
        //显示状态栏
        application.statusBarHidden = NO;

        //跳转到主界面
        self.window.rootViewController = [[WZMainViewController alloc] init];
        
    }else{
        //将新的版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
         //立刻将信息同步到沙盒中
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        //展示新特性
        self.window.rootViewController = [[WZNewFeatureViewController alloc] init ];
    }
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

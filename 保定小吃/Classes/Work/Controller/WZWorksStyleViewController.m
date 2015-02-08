//
//  WZWorksStyleViewController.m
//  保定小吃
//
//  Created by 王震 on 14-9-13.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZWorksStyleViewController.h"
#import "WZMyButton.h"
#import "UIImage+WZ.h"
#import "WZPublishPictureViewController.h"
#import "WZUINavigationViewController.h"
#import "WZPublishTableViewController.h"

@interface WZWorksStyleViewController ()

@end

@implementation WZWorksStyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加按钮
    [self addBtn:@"publish-picture.png" name:@"发图片" tag:0];
    
    //添加取消按钮
    
    UIButton *desBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [desBtn setTitle:@"取消" forState:UIControlStateNormal];
    [desBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    
    
    desBtn.frame = CGRectMake(width * 0.3, height - 74, width * 0.4, 44);
    
    [desBtn addTarget:self action:@selector(clickDescBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:desBtn];
    
    
}
//点击取消按钮
-(void) clickDescBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.view.hidden = YES;
    }];
    
    
}

#pragma mark 添加按钮
- (void)addBtn:(NSString *)icon name:(NSString *)name tag:(int) tag
{
    //添加按钮
    WZMyButton *btn = [WZMyButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage: [UIImage apaterMyImage:icon] forState:UIControlStateNormal];
    
    btn.tag = tag;
    [btn setTitle:name forState:UIControlStateNormal];// 添加文字
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(20, 0, 60, 60);
    
    [UIView animateWithDuration:0.7 animations:^{
         btn.frame = CGRectMake(20, self.view.frame.size.height * 0.4, 60, 60);
    }];
   [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

#pragma mark 添加按钮点击事件
-(void)btnPressed:(UIButton*)sender{
    //开始写你自己的动作
    //NSLog(@"%ld", (long)sender.tag);

    [self dismissViewControllerAnimated:NO completion:^{
        
        [_delegate mySwitchView]; //调用代理方法切换试图

    }];
    
    

    
    
    
    
    
}



@end


//  WZNewFeatureViewController.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  用于显示应用新特性

#import "WZNewFeatureViewController.h"
#import "WZMainViewController.h"
#import "UIImage+WZ.h"

#define  kCount 4 // 展示4张新特性

@interface WZNewFeatureViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    CGSize _size;
}
@end

@implementation WZNewFeatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        
        //self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}
#pragma  mark 加载scorll
- (void)laodMyScorll
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO;//隐藏水平条
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0);//设置scroll的尺寸
    
    scroll.pagingEnabled = YES;
    
    scroll.delegate = self;
    
    _scrollView = scroll;
    
    
    //获取Scroll的尺寸
    _size = [self getMyScrollSize];

    [self.view addSubview:_scrollView];
    
}
#pragma  mark 添加新特性图片
- (void)loadMyNewFeaturePic
{
   
   
    for (int i = 0; i < kCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"prologue_%d.jpg", i];
        //调取适配图片
        imageView.image = [UIImage apaterMyImage:imageName];
        
        imageView.frame = CGRectMake(_size.width * i, 0, _size.width , _size.height);
        
        
        if(i == kCount - 1){//当展现出最后一个图片时
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            //button.backgroundColor = [UIColor redColor];
            //显示按钮正常状态下的图片
            UIImage *imageNormal = [UIImage imageNamed:@"new_feature_finish_button.png"];
            //按钮长按时显示的图片
            UIImage *imageHighLighted = [UIImage imageNamed:@"new_feature_finish_button_highlighted.png"];
            start.bounds = CGRectMake( 0, 0, imageNormal.size.width, imageNormal.size.height);
            start.center = CGPointMake(_size.width * 0.5, _size.height*0.8);
             //显示按钮正常状态下的图片
            [start setBackgroundImage:imageNormal forState:UIControlStateNormal];
             //按钮长按时显示的图片
            [start setBackgroundImage:imageHighLighted  forState:UIControlStateHighlighted];
            
            //添加按钮点击事件
            [start addTarget:self action:@selector(startHome:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            [imageView addSubview:start];
            //NSLog(@"%d", i);
        }
        
        imageView.userInteractionEnabled = YES;//启用用户接口
        [_scrollView addSubview:imageView];
        
    }
}


#pragma  mark 获取Scroll的尺寸
- (CGSize)getMyScrollSize
{
    CGSize size = _scrollView.frame.size;
    return size;
}


#pragma  mark 添加分页指示器
- (void)loadMyPage
{
    
    UIPageControl *page =[[UIPageControl alloc] init];
    page.numberOfPages = kCount;//显示分页页数
    // 设置分页指示器显示的位置
    page.center = CGPointMake(_size.width * 0.5, _size.height * 0.95);
    //设置分页显示宽度
    page.bounds = CGRectMake(0, 0, 150, 0);
    //设置当前页显示图片
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    //设置其他页面显示图片
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    _pageControl = page;
    [self.view addSubview:_pageControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载scorll
    [self laodMyScorll];
    
    
     //添加新特性图片
    [self loadMyNewFeaturePic];
    
    //添加分页指示器
    [self loadMyPage];
    
}



#pragma  mark 添加scroll滚动事件监听
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置分页的当前页面
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;

}

#pragma  mark 添加按钮点击事件，跳转到主页面
-(void)startHome:(UIButton *)btn
{
   // NSLog(@"sdfsdfasd");
    //显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    //跳转到主界面
    self.view.window.rootViewController = [[WZMainViewController alloc] init];
    
}


@end

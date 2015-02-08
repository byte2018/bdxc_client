//
//  WZImagePage.m
//  保定小吃
//
//  Created by 王震 on 14-8-6.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZImagePage.h"
#import "UIImage+WZ.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "WZMsgShowViewController.h"
#import "WZUINavigationViewController.h"
#define  kCount 4 // 展示4张新特性

@interface WZImagePage()

{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    CGSize _size;
}
@end

@implementation WZImagePage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //加载scorll
        [self laodMyScorll:frame];
        
    }
    return self;
}

-(void) makeInit
{
    //添加新特性图片
    [self loadMyNewFeaturePic];
    
    //添加分页指示器
    [self loadMyPage];
    //切换轮播图片
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:5
                                                    target:self
                                                  selector:@selector(switchShowImages)
                                                  userInfo:nil
                                                   repeats:YES];
}

#pragma  mark 加载scorll
- (void)laodMyScorll:(CGRect)myFrame
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame  = myFrame;
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0);//设置scroll的尺寸
    
    scroll.pagingEnabled = YES;
    
    scroll.delegate = self;
    
    _scrollView = scroll;
    
    
    //获取Scroll的尺寸
    _size = [self getMyScrollSize];
    
    [self addSubview:_scrollView];
    
}
#pragma  mark 添加新特性图片
- (void)loadMyNewFeaturePic
{
    NSLog(@"%@", _listPics);
    for(int i = 0; i < _listPics.count; i++){
        NSMutableDictionary * dic = [_listPics objectAtIndex:i];
      
        
        UIImageView * imageView  = [[UIImageView alloc] init];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString: [dic objectForKey:@"pic"]]
                      placeholderImage:[UIImage imageNamed:@"icon.png"]];
        
       
        imageView.frame = CGRectMake(_size.width * i, 0, _size.width , _size.height);
        imageView.tag = i;
        
        imageView.userInteractionEnabled = YES;//启用用户接口
        
        //单指点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(showContent:)];
        [imageView addGestureRecognizer:singleTap];
        
        [_scrollView addSubview:imageView];
        
        
        

    }
    
//    for (int i = 0; i < kCount; i++) {
//        
//        UIImageView *imageView = [[UIImageView alloc] init];
//        NSString *imageName = [NSString stringWithFormat:@"prologue_%d.jpg", i];
//        //调取适配图片
//        imageView.image = [UIImage apaterMyImage:imageName];
//        
//        imageView.frame = CGRectMake(_size.width * i, 0, _size.width , _size.height);
//        
//        
//        
//        imageView.userInteractionEnabled = YES;//启用用户接口
//        [_scrollView addSubview:imageView];
//        
//    }
}

#pragma mark 点击轮播图片显示详细信息
-(void)showContent:(UITapGestureRecognizer *)recognizer
{
    NSMutableDictionary * dic = [_listPics objectAtIndex:recognizer.view.tag];
    
    [_delegate redirectContent:[[dic objectForKey:@"aid"] intValue]];
    
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
    [self addSubview:_pageControl];
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
    //self.view.window.rootViewController = [[WZMainViewController alloc] init];
    
}
#pragma mark 切换轮播图片
-(void)switchShowImages
{
    NSInteger selectedPage= _pageControl.currentPage + 1;
    if( selectedPage > 3){
        selectedPage = 0;
    }
   
    [_scrollView setContentOffset:CGPointMake(selectedPage * self.frame.size.width, 0) animated:YES];
    
  
}

@end

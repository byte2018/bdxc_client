//
//  WZMsgShowViewController.m
//  保定小吃
//
//  Created by 王震 on 14/10/23.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  用于默认首页cell点击内容展示

#import "WZMsgShowViewController.h"
#import "WZHTTPTool.h"
#import "Common.h"

@interface WZMsgShowViewController ()<MyReloadDataDelegate>
{
    NSDictionary *_responseDic;//获得返回数据
    UIWebView *_webView;
    NSMutableArray *_listData;//存储数据
   
    NSMutableDictionary *_params;//携带参数
   
    WZHTTPTool *_httpTool;

}
@end

@implementation WZMsgShowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加返回按钮
    [self addTitleLeftBtn];
    
    //添加web试图
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:_webView];
    //加载网络数据
    [self loadMyData];
    
}
#pragma mark 加载网络数据
- (void)loadMyData {
    _httpTool = [[WZHTTPTool alloc] init];
    _httpTool.delegate = self;
    
    _params = [NSMutableDictionary dictionary];
    _listData = [NSMutableArray array];
    NSString *id = [NSString stringWithFormat:@"%d", _index];
    
    [_params setObject:id forKey:@"aid"];
    [_params setObject:@"content" forKey:@"action"];
    [_httpTool httpPostJsonRequest:HOSTNAME myPath:@"portal.php" param:_params];
}


#pragma mark 添加返回按钮
- (void)addTitleLeftBtn
{
    //添加返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    backBtn.frame = CGRectMake(0, 0, 50, 32);
    //添加点击事件
    [backBtn addTarget:self action:@selector(clcikBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = backBar;
}

#pragma mark 点击注册按钮
-(void)clcikBackBtn
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark 通过代理调用返回后的数据
-(void)myReloadData: (NSDictionary *)resDict
{
    _responseDic = resDict;
   NSLog(@"%@", resDict);
     NSDictionary *dataDic  = [_responseDic objectForKey:@"data"];
    
    self.navigationItem.title =[dataDic objectForKey:@"title"];
    [_webView loadHTMLString:[dataDic objectForKey:@"content"] baseURL:nil];
    
    
//    [_webView setScalesPageToFit:YES];
}

















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

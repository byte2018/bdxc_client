//
//  WZHomeTableViewController.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  默认保定小吃展示页面

#import "WZHomeTableViewController.h"
#import "WZHTTPTool.h"
#import "Common.h"
#import "WZImageTool.h"
#import "WZImagePage.h"
#import "UIImage+WZ.h"
#import "WZLoginViewController.h"
#import "WZRegisterViewController.h"
#import "WZUINavigationViewController.h"
#import "UIImageView+WebCache.h"
#import "WZMsgShowViewController.h"

#define KTitleHeight 13  //定义标题高度
#define KDetailTextHeight 12  //定义摘要高度

@interface WZHomeTableViewController () <MyReloadDataDelegate, MySwitchViewDelegate, MyImageIndexDelegate>
{
    NSMutableArray *_listData;//存储数据
    NSString *_url;//访问url
    NSMutableDictionary *_params;//携带参数
    NSDictionary *_responseDic;//获得返回数据
    UIRefreshControl *_rc;//刷新组件
    WZHTTPTool *_httpTool;
}

@end

@implementation WZHomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self myRefreshLoadData];
    
    //添加标题按钮
    
    //添加登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [loginBtn setImage:[UIImage apaterMyImage:@"login.png"] forState:UIControlStateNormal];
    
    loginBtn.frame = CGRectMake(0, 0, 22, 22);
    //添加点击事件
    [loginBtn addTarget:self action:@selector(clcikLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *loginBar = [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
    
    //添加刷新按钮
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //正常显示图片
    [refreshBtn setBackgroundImage:[UIImage apaterMyImage:@"navigationButtonRefresh.png"] forState:UIControlStateNormal];
    //高亮显示图片
    [refreshBtn setBackgroundImage:[UIImage apaterMyImage:@"navigationButtonRefreshClick.png"] forState:UIControlStateHighlighted];
    [refreshBtn addTarget:self action:@selector(refreshBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    refreshBtn.frame = CGRectMake(0, 0, 32, 32);
    
    UIBarButtonItem *refreshbar = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];

    self.navigationItem.leftBarButtonItem = loginBar;
    self.navigationItem.rightBarButtonItem = refreshbar;
    
}

#pragma mark 点击刷新按钮
-(void) refreshBtnclick
{
    //抓取后台数据
    [self myRefreshLoadData];
}

#pragma mark 点击登录按钮，跳转到登录页面
-(void)clcikLoginBtn
{
    
    WZLoginViewController* loginController=[[WZLoginViewController alloc]init];
    loginController.delegate = self;
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginController];
   
    [self presentViewController:loginNav animated:YES completion:nil];

}
#pragma  mark 跳转到注册页面
-(void)mySwitchView
{
    //跳转到注册页面
    WZRegisterViewController * registerViewController = [[WZRegisterViewController alloc] init];
    WZUINavigationViewController *registerNav = [[WZUINavigationViewController alloc] initWithRootViewController:registerViewController];
    
    [self presentViewController:registerNav animated:YES completion:^{
        
    }];
    
}


#pragma mark 下载刷新组件
- (void)myRefreshLoadData
{
    _httpTool = [[WZHTTPTool alloc] init];
    _httpTool.delegate = self;
    
    _params = [NSMutableDictionary dictionary];
    _listData = [NSMutableArray array];
    
    [_httpTool httpPostJsonRequest:HOSTNAME myPath:@"portal.php" param:_params];
    
    //初始化UIRefreshControl
    _rc = [[UIRefreshControl alloc] init];
    _rc.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = _rc;
}

#pragma mark 用于处理刷新事件
-(void)refreshTableView
{
    if(self.refreshControl.refreshing){
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
        [_httpTool httpPostJsonRequest:HOSTNAME myPath:@"portal.php" param:_params];
    }
    

}


#pragma mark 结束刷新更新数据
-(void) reloadView:(NSDictionary *)res
{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    
    NSNumber * resultCount = [res objectForKey:@"count"]; //获得后台数据条数
    //如果获得条数为0，则访问失效
    if([resultCount integerValue] > 0){
         _listData = [_responseDic objectForKey:@"data"];
        [self.tableView reloadData];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"加载失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    
}


#pragma mark 设置header cell
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio
{
   
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    //NSLog(@"%ld", _listData.count);
    return _listData.count;
}

//自动设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *stringData = [_listData objectAtIndex:indexPath.row];
    
    NSString *name = [stringData objectForKey:@"title"];
    NSString *detailTextLabel = [stringData objectForKey:@"summary"];
    
    NSString *str = [name stringByAppendingString:detailTextLabel];
    
    UIFont *tfont = [UIFont systemFontOfSize:KDetailTextHeight];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    ////////   ios 7
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    /////////ios 6
//    CGSize sizeText1 = [str sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:NSLineBreakByCharWrapping];
   
    
    return sizeText.height+60;///////这个60 完全是根据你的情况调整的
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //这是具有故事版的情况下采用此种方式
//    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    //设置标题行数为1
    [cell.textLabel setNumberOfLines:1];
    //设置标题字体
    cell.textLabel.font = [UIFont systemFontOfSize:KTitleHeight];
    //设置内容行数为自动换行
    [cell.detailTextLabel setNumberOfLines:0];
    NSMutableDictionary *dict = _listData[indexPath.row];
   
    //设置表格字体详情
    cell.detailTextLabel.font = [UIFont systemFontOfSize:KDetailTextHeight];
    //设置摘要显示2行
    [cell.detailTextLabel setNumberOfLines:2];
   
    UIImageView * myFoodIcon  = [[UIImageView alloc] init];
    
    [myFoodIcon sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]]
                  placeholderImage:[UIImage imageNamed:@"icon.png"]];
        
    UIImage *image = myFoodIcon.image;
   
    //设置图片大小
    CGSize size = CGSizeMake(50.0f, 50.0f);
    image = [WZImageTool reSizeImage:image toSize:size];
    //为表格添加图片
    [cell.imageView setImage:image];
    
    
    cell.textLabel.text = [dict objectForKey:@"title"];//添加小吃名称
    //添加摘要
    cell.detailTextLabel.text = [dict objectForKey:@"summary"];
    //清除表格背景
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma mark-点击cell的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //跳转到内容展示页面
    WZMsgShowViewController * msgShowViewController = [[WZMsgShowViewController alloc] init];
    NSMutableDictionary *dict = _listData[indexPath.row];
   
    msgShowViewController.index =[[dict objectForKey:@"aid"] intValue];
    
    WZUINavigationViewController *msgShowNav = [[WZUINavigationViewController alloc] initWithRootViewController:msgShowViewController];
    
    [self presentViewController:msgShowNav animated:YES completion:^{
        
    }];

    
}

#pragma mark 点击轮播图片显示详细信息
-(void)redirectContent:(NSInteger *) aid
{
    //跳转到内容展示页面
    WZMsgShowViewController * msgShowViewController = [[WZMsgShowViewController alloc] init];
    
    msgShowViewController.index = aid;
    
    WZUINavigationViewController *msgShowNav = [[WZUINavigationViewController alloc] initWithRootViewController:msgShowViewController];
    
    [self presentViewController:msgShowNav animated:YES completion:^{
        
    }];


}



#pragma mark 刷新
-(void)myReloadData: (NSDictionary *)resDict
{
    _responseDic = resDict;
    
    
    WZImagePage *imagePage = [[WZImagePage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.3)];
    imagePage.delegate = self;
    imagePage.listPics = [_responseDic objectForKey:@"addata"];
    [imagePage makeInit];
    
    //跟随cell一起滚动
    self.tableView.tableHeaderView=imagePage;
    
    [self.tableView addSubview:imagePage];
    
    
    if(!_rc.refreshing){//如果不是第一次进入，则不进行刷新
        // 自行创建下拉动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        self.tableView.contentOffset = CGPointMake(0.0, -150.0); // 注意位移点的y值为负值
        [UIView commitAnimations];
        [self.refreshControl beginRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
        
        // 结束表格视图刷新
        [self performSelector:@selector(reloadView:) withObject:_responseDic afterDelay:2];
        
    }else{
         // 结束表格视图刷新
        [self performSelector:@selector(reloadView:) withObject:_responseDic afterDelay:2 ];
    }
}

@end

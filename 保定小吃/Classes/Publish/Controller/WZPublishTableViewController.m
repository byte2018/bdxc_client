//
//  WZPublishTableViewController.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//   用于作品展示栏目

#import "WZPublishTableViewController.h"
#import "WZCustomTableViewCell.h"
#import "WZPublishShow.h"
#import "WZImageTool.h"
#import "WZHTTPTool.h"
#import "Common.h"
#import "WZStatusCellFrame.h"
#import "UIImage+WZ.h"
#import "WZWorksStyleViewController.h"
#import "WZPublishPictureViewController.h"
#import "WZWorksStyleViewController.h"
#import "WZUINavigationViewController.h"
#import "svpulltorefresh.h"

#define KPageSize 40 //定义展示的条数
@interface WZPublishTableViewController () <MySwitchViewDelegate, MyReloadDataDelegate>

{
    NSInteger _page ;
    NSString *_url;//访问url
    NSMutableDictionary *_params;//携带参数
    NSDictionary *_responseDic;//获得返回数据
    UIRefreshControl *_rc;//刷新组件
    WZHTTPTool *_httpTool;

}
@end

@implementation WZPublishTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    _page = 1;
    //添加自定义导航栏
    [self addMyNavigationItem];

    
    
    //抓取后台数据
    [self myRefreshLoadData];
    
    __weak WZPublishTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    
}

#pragma mark 上拉刷新
-(void)insertRowAtBottom {
    //加载更多数据
    _httpTool = [[WZHTTPTool alloc] init];
    _httpTool.delegate = self;
    
    _params = [NSMutableDictionary dictionary];
    [_params setObject:[NSString stringWithFormat:@"%d", ++_page] forKey:@"page"];
    [_params setObject:[NSString stringWithFormat:@"%d", KPageSize] forKey:@"pageSize"];
    [_params setObject:@"index" forKey:@"action"];
    [_httpTool httpPostJsonRequestForLoadMore:HOSTNAME myPath:@"forum.php" param:_params];
}

#pragma mark 刷新
-(void)myLoadMoreData: (NSDictionary *)resDict
{
    _moreData = [resDict objectForKey:@"data"];
    __weak WZPublishTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        
        [arrM addObjectsFromArray:weakSelf.listData];
        
        //准备插入数据
        NSMutableArray *insertIndexPaths = [NSMutableArray array];
        
        
        for(int i = 0; i < _moreData.count; i++){
            [arrM addObject:_moreData[i]];//添加新数据
            NSInteger indexPathRow  = weakSelf.listData.count+i;
            NSIndexPath *newPath = [NSIndexPath indexPathForRow:indexPathRow inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        weakSelf.listData = arrM;
        
        [weakSelf.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
    
}


#pragma mark 下载刷新组件
- (void)myRefreshLoadData
{
    _page = 1;
    _httpTool = [[WZHTTPTool alloc] init];
    _httpTool.delegate = self;
    
    _params = [NSMutableDictionary dictionary];
    [_params setObject:@"index" forKey:@"action"];
    [_params setObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page"];
    [_params setObject:[NSString stringWithFormat:@"%d", KPageSize] forKey:@"pageSize"];

    
     [_httpTool httpPostJsonRequest:HOSTNAME myPath:@"forum.php" param: _params];
    
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
        _page = 1;
        _httpTool = [[WZHTTPTool alloc] init];
        _httpTool.delegate = self;
        
        _params = [NSMutableDictionary dictionary];
        [_params setObject:@"index" forKey:@"action"];
        [_params setObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page"];
        [_params setObject:[NSString stringWithFormat:@"%d", KPageSize] forKey:@"pageSize"];
        
        
        [_httpTool httpPostJsonRequest:HOSTNAME myPath:@"forum.php" param: _params];    }
    
    
}



#pragma mark 添加自定义导航栏
- (void)addMyNavigationItem
{
    //添加发布按钮
    UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //正常显示图片
    [editorBtn setBackgroundImage:[UIImage apaterMyImage:@"navigationButtonPublish.png"] forState:UIControlStateNormal];
    //高亮显示图片
    [editorBtn setBackgroundImage:[UIImage apaterMyImage:@"navigationButtonPublishClick.png"] forState:UIControlStateHighlighted];
    
    
    editorBtn.frame = CGRectMake(0, 0, 32, 32);
    self.title = @"作品发布";
    UIBarButtonItem *publishBar = [[UIBarButtonItem alloc] initWithCustomView:editorBtn];
    
    //设置编辑按钮点击事件
    [editorBtn addTarget:self action:@selector(editorBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加刷新按钮
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //正常显示图片
    [refreshBtn setBackgroundImage:[UIImage apaterMyImage:@"navigationButtonRefresh.png"] forState:UIControlStateNormal];
    //高亮显示图片
    [refreshBtn setBackgroundImage:[UIImage apaterMyImage:@"navigationButtonRefreshClick.png"] forState:UIControlStateHighlighted];
    [refreshBtn addTarget:self action:@selector(refreshBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    refreshBtn.frame = CGRectMake(0, 0, 32, 32);
    
    UIBarButtonItem *refreshbar = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
   
    self.navigationItem.leftBarButtonItem = publishBar;
    self.navigationItem.rightBarButtonItem = refreshbar;
}

#pragma mark 点击刷新按钮
-(void) refreshBtnclick
{
    _page = 1;
    //抓取后台数据
    [self myRefreshLoadData];
}



#pragma mark 自动设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *data = [_listData objectAtIndex:indexPath.row];
    WZCustomTableViewCell *cell = [[WZCustomTableViewCell  alloc] init];
    
    WZStatusCellFrame *statusCellFrame =[[WZStatusCellFrame alloc] init];
    WZPublishShow * publicShow = [statusCellFrame getMyPublicShow:data];
    cell.publicShow = publicShow;
    
    CGFloat cellHeight = [cell addCustomStyle];
    return  cellHeight+10;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return  _listData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *data = [_listData objectAtIndex:indexPath.row];
   
    tableView.separatorStyle = NO;//去除cell分割线
    static NSString *CellIdentifier = @"CustomCell";
    
    WZCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //这是具有故事版的情况下采用此种方式
    //    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //获得Cell布局
//    cell.tag = 1;
    if (cell == nil) {
        cell = [[WZCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
    }else{
        // 删除cell中的子对象,刷新覆盖问题。
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
    }
    WZStatusCellFrame *statusCellFrame =[[WZStatusCellFrame alloc] init];
    
    WZPublishShow * publicShow = [statusCellFrame getMyPublicShow:data];
    
    cell.publicShow = publicShow;

    [cell addCustomStyle];
    
   
    return cell;
}

#pragma mark 编辑按钮点击事件
-(void)editorBtnclick
{
    
    
    
    WZWorksStyleViewController* styleController=[[WZWorksStyleViewController alloc]init];
    
    styleController.delegate = self;
    [self presentViewController:styleController animated:YES completion:nil];
    
    
}

#pragma  mark 跳转到图片发布页面
-(void)mySwitchView
{
    //跳转到图片发布页面
    WZPublishPictureViewController * publishPictureViewController = [[WZPublishPictureViewController alloc] init];
    WZUINavigationViewController *publishNav = [[WZUINavigationViewController alloc] initWithRootViewController:publishPictureViewController];
    
    [self presentViewController:publishNav animated:NO completion:^{
        
    }];


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


#pragma mark 刷新
-(void)myReloadData: (NSDictionary *)resDict
{
    _responseDic = resDict;
   
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

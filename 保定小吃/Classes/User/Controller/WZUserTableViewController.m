//
//  WZUserTableViewController.m
//  保定小吃
//
//  Created by 王震 on 14-9-16.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZUserTableViewController.h"
#import "WZCustomerTableViewCell.h"
#import "UIImage+WZ.h"
#import "WZLoginViewController.h"
#import "WZRegisterViewController.h"
#import "WZUINavigationViewController.h"

@interface WZUserTableViewController ()<MySwitchViewDelegate>
{
    NSArray *_listData;//获得cell配置集合
    NSDictionary * _userMsg;//获得用户信息
}
@end

@implementation WZUserTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //读取配置文件
    [self readPlist];
   
    //定制退出按钮
    UIView *myView = [[UIView alloc]init];
    
     UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    
    [exitBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    
    [exitBtn addTarget:self action:@selector(clickExitBtn) forControlEvents:UIControlEventTouchUpInside];
    
    long width = self.view.frame.size.width;
    exitBtn.frame = CGRectMake(width * 0.2, 0, width * 0.6, 44);
    
    [myView addSubview:exitBtn];
    //tableFooterView的宽度是不需要设置的，默认填充整个cell
    myView.bounds = CGRectMake(0, 0, 0, 44);
    self.tableView.tableFooterView = myView;
}

#pragma  mark 点击退出登录
-(void)clickExitBtn
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    _userMsg= [defaults objectForKey:@"user"];//根据键值取出user信息
    if(_userMsg == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有登录哟" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        [alert show];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"换个账号再来一发" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }

}

#pragma  mark 监听alert事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){//点击确定
        if(_userMsg != nil){
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:@"user"];//清空用户信息
            [defaults synchronize];
        }
        WZLoginViewController* loginController=[[WZLoginViewController alloc]init];
        loginController.delegate = self;
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginController];
        
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    
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


#pragma  mark 读取配置文件
- (void)readPlist
{
    //读取配置文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"group" ofType:@"plist"];
    
    _listData = [[NSArray alloc] initWithContentsOfFile: filePath];
}


#pragma  mark 设置顶部Section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
    
}
#pragma  mark 设置Section底部距下一个Section的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listData[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //去除cell之间的分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WZCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
    
    if (cell == nil) {
        cell = [[WZCustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
        UIImageView *bg = [[UIImageView alloc] init];
        
        cell.backgroundView = bg;
        
        UIImageView *bg2 = [[UIImageView alloc] init];
        
        cell.selectedBackgroundView = bg2;
        
        
        
    }
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = _listData[indexPath.section][indexPath.row];
  
    cell.textLabel.text = [dic objectForKey:@"name"];
    
    UIImageView *bg = (UIImageView *)cell.backgroundView;
    UIImageView *bg2 = (UIImageView *)cell.selectedBackgroundView;
    
    
//    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5 ];//拉伸图片
    long count = [_listData[indexPath.section] count];
    
    if(count == 1){
         bg.image = [UIImage tileMyImage:@"common_card_background.png"];
       bg2.image = [UIImage tileMyImage:@"common_card_background_highlighted.png"];

    }else if(indexPath.row == 0 ){//当组首行
        bg.image = [UIImage tileMyImage:@"common_card_top_background.png"];
        bg2.image = [UIImage tileMyImage:@"common_card_top_background_highlighted.png"];
    }else if(indexPath.row == count - 1){//当组尾行
        bg.image = [UIImage tileMyImage:@"common_card_bottom_background.png"];
        bg2.image = [UIImage tileMyImage:@"common_card_bottom_background_highlighted.png"];
    }else{//当组中间行
        bg.image = [UIImage tileMyImage:@"common_card_middle_background.png"];
        bg2.image = [UIImage tileMyImage:@"common_card_middle_background_highlighted.png"];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end

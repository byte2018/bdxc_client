//
//  WZLoginViewController.m
//  保定小吃
//
//  Created by 王震 on 14-9-20.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  用于用户登录

#import "WZLoginViewController.h"
#import "UIImage+WZ.h"
#import "WZRegisterViewController.h"
#import "WZUINavigationViewController.h"
#import "WZHTTPTool.h"
#import "Common.h"
#import "validation.h"

@interface WZLoginViewController ()<MyReloadDataDelegate>
{
    UIScrollView *_scrollView;
    WZHTTPTool *_httpTool;
    NSMutableDictionary *_params;//携带参数
    UITextField * _usernameText;//用户名
    UITextField * _passwordText;//密码
}
@end

@implementation WZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark 添加登录布局
- (void)addDisplay
{
    //添加登录页面布局
    //添加用户名输入框
    UILabel *userName = [[UILabel alloc] init];
    userName.text = @"用户名";
    long width = self.view.frame.size.width;
    long height = self.view.frame.size.height;
    long leftMargin = width * 0.1;
    userName.frame = CGRectMake(leftMargin, height * 0.1, width*0.2, 44);
    
   _usernameText = [[UITextField alloc] init];
    _usernameText.placeholder = @"请输入用户名";
    
    _usernameText.frame = CGRectMake(leftMargin +  width*0.2 + 5, height * 0.1, width*0.5, 44);
    
    //添加密码输入框
    UILabel *password = [[UILabel alloc] init];
    password.text = @"密  码";
    
    
    password.frame = CGRectMake(leftMargin, height * 0.2 , width*0.2, 44);
    
    _passwordText = [[UITextField alloc] init];
    _passwordText.placeholder = @"请输入密码";
    _passwordText.secureTextEntry = YES;//加密输入
    _passwordText.frame = CGRectMake(leftMargin +  width*0.2 + 5, height * 0.2 , width*0.5, 44);
    
    
    //添加登录和注册按钮
    //添加登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    
    [loginBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    loginBtn.frame = CGRectMake(leftMargin,  height * 0.3 , width * 0.3, 44);
    
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //添加注册按钮
    UIButton *resgisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resgisBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    
    [resgisBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    [resgisBtn setTitle:@"注册" forState:UIControlStateNormal];
    
    resgisBtn.frame = CGRectMake(leftMargin +  width * 0.3 + 20,  height * 0.3 , width * 0.3, 44);
    
    [resgisBtn addTarget:self action:@selector(clickResgisBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect size =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.6);
    _scrollView = [[UIScrollView alloc] initWithFrame:size];
    
    [_scrollView addSubview:resgisBtn];
    [_scrollView addSubview:loginBtn];
    [_scrollView addSubview:_usernameText];
    [_scrollView addSubview:userName];
    [_scrollView addSubview:_passwordText];
    [_scrollView addSubview:password];
    
    [self.view addSubview:_scrollView];
    //键盘将要出现时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark 键盘将要出现时出现
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;//获取键盘的size值
    //NSLog(@"value %@ %f",value,keyboardSize.height);
    //获取键盘出现的动画时间
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
//    CGFloat height =keyboardSize.height;
    //NSLog(@"height = %f",height);
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 0.6);
    
    [UIView commitAnimations];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"登录界面哟";
    //添加返回按钮
    [self addTitleLeftBtn];
    //添加登录布局
    [self addDisplay];
    

}

#pragma mark 点击注册按钮
-(void)clickResgisBtn
{
  
    
    [self dismissViewControllerAnimated:NO completion:^{
         [_delegate mySwitchView]; //调用代理方法切换试图
    }];
    

}


#pragma mark 点击登录按钮
-(void)clickLoginBtn
{
    //====== Initialize The Validation Library
    validation *validate=[[validation alloc] init];
    [validate Required:_usernameText.text FieldName:@"用户名"];
    
    [validate MinLength:6 textFiled:_passwordText.text FieldName:@"密码"];
    if([validate isValid] == TRUE){
        _params = [NSMutableDictionary dictionaryWithCapacity:2];
        
        [_params setObject:_usernameText.text forKey:@"user.userName"];
        [_params setObject:_passwordText.text forKey:@"user.password"];
        _httpTool = [[WZHTTPTool alloc] init];
        [_httpTool httpPostJsonRequest:HOSTNAME myPath:@"user_loginUser.action" param:_params];
        _httpTool.delegate = self;
        
    }else{
       
        NSString *errorString = [[validate errorMsg] componentsJoinedByString: @"\n"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
   
    
//    NSLog(@"%@", _params );
    
    
}

#pragma mark 获得登录返回数据
-(void)myReloadData: (NSDictionary *)resDict
{
   
    NSString *result = [resDict objectForKey:@"result"];
    
    BOOL flag = [@"success" isEqualToString:result];//判断字符串是否相同
    if(flag){
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
       
        [defaults setObject:[resDict objectForKey:@"data"] forKey:@"user"];
        
        [defaults synchronize];//用synchronize方法把数据持久化到standardUserDefaults数据库
        //返回上一试图
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录名和密码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }
    
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSDictionary * userMsg= [defaults objectForKey:@"user"];//根据键值取出user信息
//    NSLog(@"%@", userMsg);
}

#pragma mark 添加返回按钮
- (void)addTitleLeftBtn
{
    //添加返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    backBtn.frame = CGRectMake(0, 0, 50, 32);
    //添加点击事件
    [backBtn addTarget:self action:@selector(clcikBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = backBar;
}

#pragma mark 点击取消按钮
-(void)clcikBackBtn
{
    //返回上一试图
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];

}

@end

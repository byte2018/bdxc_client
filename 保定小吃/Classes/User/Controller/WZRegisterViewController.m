//
//  WZRegisterViewController.m
//  保定小吃
//
//  Created by 王震 on 14-10-2.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  用户注册界面

#import "WZRegisterViewController.h"
#import "UIImage+WZ.h"
#import "WZHTTPTool.h"
#import "Common.h"
#import "validation.h"

@interface WZRegisterViewController () <UIActionSheetDelegate,UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, MyReloadDataDelegate>
{
    UIScrollView *_scrollView;
    NSInteger _isFlag; //判读是否选中照片
    UITextField * _usernameText;//用户名
    UITextField * _passwordText;//密码
    UITextField * _emailText;//邮箱
    UITextField * _telText;//手机号
    
    UILabel * _isImagesFlag;
    
    WZHTTPTool *_httpTool;
    
}

@end

@implementation WZRegisterViewController

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
    
    //添加注册布局
    [self addDisplay];
    
    //添加标题按钮
    [self addTitleBtn];
    
    
    _isFlag = 0;//0：表示未上传图片，1表示上传图片

}

#pragma  mark 添加标题按钮
- (void)addTitleBtn
{
    //添加发布按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //正常显示图片
    [publishBtn setTitle:@"注册"  forState:UIControlStateNormal];
    //高亮显示图片
    [publishBtn setTitle:@"注册" forState:UIControlStateHighlighted];
    [publishBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [publishBtn addTarget:self action:@selector(clcikPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    publishBtn.frame = CGRectMake(0, 0, 50, 32);
    
    //添加取消按钮
    UIButton *myCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    //正常显示
    [myCancel setTitle:@"取消"  forState:UIControlStateNormal];
    //高亮显示
    [myCancel setTitle:@"取消" forState:UIControlStateHighlighted];
    [myCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [myCancel setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [myCancel addTarget:self action:@selector(clcikMyCancel) forControlEvents:UIControlEventTouchUpInside];
    myCancel.frame = CGRectMake(0, 0, 50, 32);
    
    
    
    
    self.title = @"注册";
    UIBarButtonItem *publishBar = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithCustomView:myCancel];
    self.navigationItem.leftBarButtonItem = cancelBar;
    self.navigationItem.rightBarButtonItem = publishBar;
}

#pragma  mark 点击取消按钮返回上一目录
-(void) clcikMyCancel
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}


#pragma mark 添加注册布局
- (void)addDisplay
{
    //添加登录页面布局
    //添加用户名输入框
    UILabel *userName = [[UILabel alloc] init];
    userName.text = @"用户名";
    long width = self.view.frame.size.width;
    long height = self.view.frame.size.height;
    long leftMargin = width * 0.1;
    userName.frame = CGRectMake(leftMargin, height * 0.2, width*0.2, 44);
    
    _usernameText = [[UITextField alloc] init];
    _usernameText.placeholder = @"请输入用户名";
    
    _usernameText.frame = CGRectMake(leftMargin +  width*0.2 + 5, height * 0.2, width*0.5, 44);
    
    //添加密码输入框
    UILabel *password = [[UILabel alloc] init];
    password.text = @"密  码";
    
    
    password.frame = CGRectMake(leftMargin, height * 0.3, width*0.2, 44);
    
    _passwordText = [[UITextField alloc] init];
    _passwordText.placeholder = @"请输入密码";
    _passwordText.secureTextEntry = YES;//加密输入
    _passwordText.frame = CGRectMake(leftMargin +  width*0.2 + 5, height * 0.3, width*0.5, 44);
    
    
    UILabel *email = [[UILabel alloc] init];
    email.text = @"邮  箱";
    
    email.frame =  CGRectMake(leftMargin, height * 0.4 , width*0.2, 44);

    _emailText = [[UITextField alloc] init];
    _emailText.placeholder = @"请输入邮箱地址";
   
    _emailText.frame = CGRectMake(leftMargin +  width*0.2 + 5, height * 0.4, width*0.5, 44);
    
    
    UILabel *tel = [[UILabel alloc] init];
    tel.text = @"手  机";
    
    tel.frame =  CGRectMake(leftMargin, height * 0.5 , width*0.2, 44);
    
    _telText = [[UITextField alloc] init];
    _telText.placeholder = @"请输入手机号码";
    
    _telText.frame = CGRectMake(leftMargin +  width*0.2 + 5, height * 0.5, width*0.5, 44);
    
    UILabel *icon = [[UILabel alloc] init];
    icon.text = @"上传头像";
    
    icon.frame =  CGRectMake(leftMargin, height * 0.6 , width*0.4, 44);
    
    UIButton * iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    [iconBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [iconBtn setBackgroundImage:[UIImage tileMyImage:@"common_card_background.png"] forState:UIControlStateNormal];
    iconBtn.frame = CGRectMake(leftMargin +  width*0.2 + 5, height * 0.6, width*0.5, 44);
    
     [iconBtn addTarget:self action:@selector(showSheet) forControlEvents:UIControlEventTouchUpInside];
    
    _isImagesFlag = [[UILabel alloc] init];
    _isImagesFlag.text = @"未上传";
    _isImagesFlag.frame =  CGRectMake(leftMargin +  width*0.2 + 10 + width*0.5  , height * 0.6 , width*0.4, 44);
    
    
    
    
    //注册按钮
   
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    
    [registerBtn setBackgroundImage:[UIImage tileMyImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    
    registerBtn.frame = CGRectMake(width * 0.3,  height * 0.7, width * 0.3, 44);
    
    
    [registerBtn addTarget:self action:@selector(clcikregisterBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
   _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    [_scrollView addSubview:_isImagesFlag];
    [_scrollView addSubview:iconBtn];
    [_scrollView addSubview:icon];
    [_scrollView addSubview:_telText];
    [_scrollView addSubview:tel];
    [_scrollView addSubview:_emailText];
    [_scrollView addSubview:email];
    [_scrollView addSubview:registerBtn];
    [_scrollView addSubview:_usernameText];
    [_scrollView addSubview:userName];
    [_scrollView addSubview:_passwordText];
    [_scrollView addSubview:password];
    
   
    
    
    
    [self.view addSubview:_scrollView];
    
    //键盘将要出现时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
//    //键盘将要消失时的触发事件
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}

#pragma  mark 点击发布按钮发布图片
-(void)clcikregisterBtn
{
    
    //====== Initialize The Validation Library
    validation *validate=[[validation alloc] init];
    [validate Required:_usernameText.text FieldName:@"用户名"];//必须输入密码
    //密码必须大于6位
    [validate MinLength:6 textFiled:_passwordText.text FieldName:@"密码"];
    //判断邮箱格式
    [validate Required:_emailText.text FieldName:@"邮箱地址"];
    
    //判断手机号码是否为纯数字
     [validate Tel:_telText.text FieldName:@"手机号码"];
     if([validate isValid] == TRUE){
         if(_isFlag){
             //上传单张图片
             //获得上传图片地址
             NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
             //访问服务器地址
             NSString *path = [[NSString alloc] initWithFormat:@"user_registerUser.action"];
             
             //需要我们初始化一个空间大小，用dictionaryWithCapacity
             NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:5];
             //这里我们给的空间大小是5,当添加的数据超过的时候，它的空间大小会自动扩大
             
             //添加数据，注意：id key  是成对出现的
             [params setObject:_usernameText.text forKey:@"user.userName"];//添加用户名
             [params setObject:_passwordText.text forKey:@"user.password"];//添加密码
             [params setObject:_emailText.text forKey:@"user.email"];//添加邮箱地址
             [params setObject:_telText.text forKey:@"user.telPhone"];//添加手机号码
             
             
             _httpTool = [[WZHTTPTool alloc] init];
              _httpTool.delegate = self;
             //上传图片
             [_httpTool uploadImage:fullPath myPath:path hostName: HOSTNAME param:params myFileParam:@"image" fileType:@"png"];
            
             
         }else{
             //如果没有上传图片，显示提示框
             UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先上传图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
             
             [alterView show];
             
         }

     }else{
         NSString *errorString = [[validate errorMsg] componentsJoinedByString: @"\n"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [alert show];
     }
    
    
}

#pragma mark 获得注册后返回数据
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[resDict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
}


#pragma  mark 实现UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex = %i", buttonIndex );
    
    if(buttonIndex == 1){
        [self showSheet];//调用sheet选择框
    }
    
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
    CGFloat height =keyboardSize.height;
    //NSLog(@"height = %f",height);
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + height);
    
    [UIView commitAnimations];
}

//-(void)keyboardWillBeHidden:(NSNotification *)aNotification
//{
//    NSDictionary *info = [aNotification userInfo];
//    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    NSTimeInterval animation = animationDuration;
//    
//    [UIView beginAnimations:@"animal" context:nil];
//    [UIView setAnimationDuration:animation];
//    self.view.frame = [[UIScreen mainScreen] bounds];
//    [UIView commitAnimations];
//}





#pragma mark 点击选择图片按钮，显示图片选择方式
-(void)showSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择头像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相册", @"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

//-(void)showAlert:(NSString *)msg {
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"Action Sheet选择项"
//                          message:msg
//                          delegate:self
//                          cancelButtonTitle:@"确定"
//                          otherButtonTitles: nil];
//    [alert show];
//}

#pragma mark 记录sheet触发选项
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//进入相册挑选图片
        
        [self toMyPhoto];
        
    }else if(buttonIndex == 1) {//进入相机拍照，上传图片
        
        [self toMyCamera];
        
    }
}


#pragma mark 进入相机，调取图片
-(void)toMyCamera
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    //[self presentModalViewController:picker animated:YES];//进入照相界面
    [self presentViewController:picker animated:YES completion:^{}];//进入照相界面
}



#pragma mark 进入相册，调取图片
-(void)toMyPhoto
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    //[self presentModalViewController:picker animated:YES];//进入照相界面
    [self presentViewController:picker animated:YES completion:^{
        
    }];//进入照相界面
}

//点击相册中的图片 或照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        _isImagesFlag.text = @"已上传";
        _isFlag = 1;
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    /* 此处info 有六个值
     08
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     09
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     10
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     11
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     12
     * UIImagePickerControllerMediaURL;       // an NSURL
     13
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     14
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     15
     */
    
    // 保存图片至本地，方法见下文
    
    [self saveImage:image withName:@"currentImage.png"];
    
    
    
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}


//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
       
    }];
    
}




- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}



@end

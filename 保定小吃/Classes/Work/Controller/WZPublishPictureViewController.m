//
//  WZPublishPictureViewController.m
//  保定小吃
//
//  Created by 王震 on 14-9-14.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZPublishPictureViewController.h"
#import "UIImage+WZ.h"
#import "WZHTTPTool.h"
#import "Common.h"
#import "WZMainViewController.h"

#define  kNum 200 //定义可输入字数

@interface WZPublishPictureViewController ()
 <UIActionSheetDelegate,UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, MyReloadDataDelegate>

{
    UITextView *_textview;
    UIView *_btnView;
    
    UILabel *_numLable;//计算字数
    
    //UIImageView *_showImage;//展示相机拍摄照片
    
    int  _isFlag;//是否选择了图片0：未上传1：以上传
    
    WZHTTPTool *_httpTool;
    
}
@end

@implementation WZPublishPictureViewController


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
    _isFlag = 0;//默认为未上传
    
    //添加标题按钮
    [self addTitleBtn];
    
    
    //添加用户发表的文字内容
    [self addMeg];
    
    
   
    
    
    
    
}
#pragma  mark 添加标题按钮
- (void)addTitleBtn
{
    //添加发布按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //正常显示图片
    [publishBtn setTitle:@"发布"  forState:UIControlStateNormal];
    //高亮显示图片
    [publishBtn setTitle:@"发布" forState:UIControlStateHighlighted];
    [publishBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [publishBtn addTarget:self action:@selector(clcikPublishBtn) forControlEvents:UIControlEventTouchUpInside];
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

    
    
    
    self.title = @"作品发布";
    UIBarButtonItem *publishBar = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithCustomView:myCancel];
    self.navigationItem.leftBarButtonItem = cancelBar;
    self.navigationItem.rightBarButtonItem = publishBar;
}

#pragma  mark 点击取消按钮返回根目录
-(void) clcikMyCancel
{
    //[self dismissViewControllerAnimated:YES completion:^{}];
//    if([_switchViewdelegate respondsToSelector:@selector(switchView:)]){
//        [_switchViewdelegate switchView:0];
//    }
    
    
    
   [self dismissViewControllerAnimated:YES completion:^{
          }];
    
}


#pragma  mark 点击发布按钮发布图片
-(void)clcikPublishBtn
{
    if(_isFlag){
        //上传单张图片
        //获得上传图片地址
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        //访问服务器地址
        NSString *path = [[NSString alloc] initWithFormat:@"publish_savePublish.action"];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSDictionary * userMsg= [defaults objectForKey:@"user"];//根据键值取出user信息
        if(userMsg != nil){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];;//存储数据
            
            [dic setObject:[userMsg objectForKey:@"id"] forKey:@"user.id"];
            [dic setObject:_textview.text forKey:@"publish.description"];
            
            _httpTool = [[WZHTTPTool alloc] init];
            _httpTool.delegate = self;
            //上传图片
            [_httpTool uploadImage:fullPath myPath:path hostName: HOSTNAME param:dic myFileParam:@"image" fileType:@"png"];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有登录哟" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        
        }
        
        
        
        
        
        
        
    }else{
        //如果没有上传图片，显示提示框
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先上传图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alterView show];
        
    }
}

#pragma mark 点击发布后返回数据
-(void)myReloadData: (NSDictionary *)resDict
{
    
    NSString *result = [resDict objectForKey:@"result"];
    
    BOOL flag = [@"success" isEqualToString:result];//判断字符串是否相同
    if(flag){
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
        [self showSheet];
    }

}



#pragma  mark 添加用户发表的文字内容
- (void)addMeg
{
//    int height = self.view.frame.size.height *0.3;
    //self.view.backgroundColor = [UIColor grayColor];
    _textview = [[UITextView alloc]init];
    
    _textview.backgroundColor=[UIColor   whiteColor]; //背景色
    _textview.returnKeyType = UIReturnKeyDefault;//return键的类型
    
    _textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    _textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    _textview.delegate = self;
    _textview.font = [UIFont systemFontOfSize:14];
    //默认调用键盘
    [_textview becomeFirstResponder];
    
    
    [self.view addSubview:_textview];
    
    
    
    
    
    //在textView下面添加操作按钮
    _btnView = [[UIView alloc] init];
    //_btnView.backgroundColor = [UIColor redColor];
    UIButton *toCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [toCamera setImage:[UIImage apaterMyImage:@"contributeCamera.png"] forState:UIControlStateNormal];
    [toCamera setImage:[UIImage apaterMyImage:@"contributeCameraClick.png"] forState:UIControlStateHighlighted];

    toCamera.frame = CGRectMake(self.view.frame.size.width - 50, 10, 30, 30);
    
    [toCamera addTarget:self action:@selector(showSheet) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_btnView addSubview:toCamera];
    
    
    
    
    
    //定义显示字数的UILable
    _numLable = [[UILabel alloc]init];
    
    //显示可输入字数
    [_numLable setText:[NSString stringWithFormat:@"还可输入%d",kNum]];
    
    [_numLable setTextColor:[UIColor blackColor]];
    _numLable.frame = CGRectMake(10, 10, 100, 30);
    
     [_btnView addSubview:_numLable];
    
    
    
    
    
    [self.view addSubview:_btnView];
    
    
//    _showImage = [[UIImageView alloc] init];
//    
//    _showImage.frame = CGRectMake(0, 30, 130, 130);
//
//    
//    [self.view addSubview:_showImage];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //
    //                                             selector:@selector(keyboardWillHide:)
    //
    //                                                 name:UIKeyboardWillHideNotification
    //
    //                                               object:nil];
}

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
         [_textview becomeFirstResponder];//默认调用键盘
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
         [_textview becomeFirstResponder];//默认调用键盘
    }];

}


#pragma  mark 如果输入超过规定的字数100，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (range.location>=kNum)
	{
		return  NO;
	}
	else
	{
		return YES;
	}
//    NSLog(@"%ld", range.location);
    
   
    
}


#pragma  mark 在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
	NSString  * nsTextContent=textView.text;
	int  existTextNum=[nsTextContent length];
	int TextNum=kNum-existTextNum;
    
     [_numLable setText:[NSString stringWithFormat:@"还可输入%d",TextNum]];
}




#pragma  mark 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height; //键盘高度
    
    
    _textview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - height - 44);
    
    _btnView.frame = CGRectMake(0, self.view.frame.size.height - height - 44, self.view.frame.size.width, 44);
    
    
}


#pragma  mark 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification

{
    
    
    
}




@end

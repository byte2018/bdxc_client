//
//  WZCategoryTableViewController.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  用于类别查询,运用网上写好的代码

#import "WZCategoryTableViewController.h"

@interface WZCategoryTableViewController () <UITextFieldDelegate>
{
    UITextField *_mySearch;
}

@end

@implementation WZCategoryTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加标签云
	[self addTagCloud];
    
    //添加更换标签云按钮
    [self addChangeBtn];
    
    //添加搜索框
    //此段代码必须位于标签云下面
    UITextField * search = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 163, 34)];
    search.center = CGPointMake(self.view.frame.size.width * 0.4, self.view.frame.size.width * 0.3);
    search.borderStyle = UITextBorderStyleRoundedRect;
    //search.enabled = YES;
    
    search.placeholder = @"请输入小吃名称";
    //search.backgroundColor = [UIColor redColor];
    //设置键盘返回键类型
    search.returnKeyType = UIReturnKeyDone;
    search.delegate = self;
    _mySearch = search;
    [self.view addSubview:_mySearch];
    
    //添加按钮
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 34)];
    
    searchButton.center = CGPointMake(self.view.frame.size.width * 0.7, self.view.frame.size.width * 0.3);
    searchButton.backgroundColor = [UIColor redColor];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(clickSearch) forControlEvents: UIControlEventTouchUpInside ];
    [self.view addSubview:searchButton];
    
    
    
}
#pragma  mark 实现的Delegate方法,关闭键盘
-(void)clickSearch
{
    NSString *searchKey =  _mySearch.text;
    [_mySearch resignFirstResponder];
    NSLog(@"%@", searchKey);
}

#pragma  mark 实现的Delegate方法,关闭键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_mySearch resignFirstResponder];
    return YES;
}

#pragma  mark 添加标签云
- (void)addTagCloud
{
    _tags = @[@"当幸福来敲门", @"海滩", @"如此的夜晚", @"大进军", @"险地", @"姻缘订三生", @"死亡城", @"苦海孤雏", @"老人与海", @"烽火异乡情", @"父亲离家时", @"无情大地补情天", @"以眼还眼", @"锦绣人生", @"修女传", @"第十三号", @"末代启示录", @"西北前线", @"西北区骑警", @"黄金广场大劫案", @"畸恋山庄", @"守夜", @"我们爱黑夜", @"恐怖夜校", @"夏尔洛结婚", @"特别的一夜", @"下一站格林威治村", @"升职记", @"恶夜之吻", @"木匠兄妹故事", ];
    NSArray* colors = @[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1], [UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1], [UIColor colorWithRed:0.53 green:0.78 blue:0 alpha:1], [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1]];
    NSArray* fonts = @[[UIFont systemFontOfSize:12], [UIFont systemFontOfSize:16], [UIFont systemFontOfSize:20]];
    //初始化
    _tagCloud = [[WWTagsCloudView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height * 0.9)
                                               andTags:_tags
                                          andTagColors:colors
                                              andFonts:fonts
                                       andParallaxRate:1.7
                                          andNumOfLine:3];
    _tagCloud.delegate = self;
    _tagCloud.userInteractionEnabled = YES;
    [self.view addSubview:_tagCloud];
}

#pragma  mark 添加更换标签云按钮
- (void)addChangeBtn
{
    UIButton *refBtn = [[UIButton alloc] init];
    //设置按钮的大小
    refBtn.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.3, 44);
    //设置按钮的位置
    refBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height * 0.8);
    //设置按钮的位置
    refBtn.backgroundColor = [UIColor redColor];
    [refBtn setTitle:@"换一批" forState:UIControlStateNormal];
    //设置按钮的点击事件
    [refBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refBtn];
}

#pragma  mark 点击标签
-(void)tagClickAtIndex:(NSInteger)tagIndex
{
    NSLog(@"%@",_tags[tagIndex]);
}

#pragma  mark 按钮点击刷新标签
- (void)refreshBtnClick {
    [_tagCloud reloadAllTags];
}
@end

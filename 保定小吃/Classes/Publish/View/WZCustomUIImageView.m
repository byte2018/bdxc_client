//
//  WZCustomUIImageView.m
//  保定小吃
//
//  Created by 王震 on 14-9-12.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//  显示内容下方按钮

#import "WZCustomUIImageView.h"
#import "UIImage+WZ.h"



#define  KNumBtn 4 //确定按钮数量

@implementation WZCustomUIImageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        
        //设置UIImageView背景图片
        [self setImage:
        [UIImage tileMyImage:@"timeline_card_bottom.png"]];
        //添加按钮
        [self addBtn:@"赞" icon:@"mainCellDing.png"
           iconClick:@"mainCellDingClick.png" tag:0];
        [self addBtn:@"菜" icon:@"mainCellCai.png"
           iconClick:@"mainCellCaiClick.png" tag:1];
        [self addBtn:@"转发" icon:@"mainCellShare.png"
           iconClick:@"mainCellShareClick.png" tag:2];
        [self addBtn:@"评论" icon:@"mainCellCommentN.png"
           iconClick:@"mainCellCommentClickN.png" tag:3];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

#pragma mark 添加按钮
- (void)addBtn:(NSString *) name  icon:(NSString *) iconImage iconClick:(NSString *) clcikImage tag:(int) index
{
    int btnWidth = (self.frame.size.width - 5) / KNumBtn;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //默认显示字体
    [btn setTitle:name forState:UIControlStateNormal];
    //高亮显示字体
    [btn setTitle:name forState:UIControlStateHighlighted];
    // 设置按钮的文本颜色
    [btn setTitleColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
    // 设置按钮的背景图片
    [btn setBackgroundImage:[UIImage tileMyImage:@"timeline_card_leftbottom.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage tileMyImage:@"timeline_card_leftbottom_highlighted.png"] forState:UIControlStateHighlighted];
    
    //设置按钮图片
    [btn setImage:[UIImage imageNamed:iconImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:clcikImage] forState:UIControlStateHighlighted];
    
    btn.frame = CGRectMake(index * btnWidth, 0, btnWidth, 44);
    
    [self addSubview:btn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

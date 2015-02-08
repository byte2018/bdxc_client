//
//  WZDock.m
//  保定小吃
//
//  Created by 王震 on 14-7-29.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZDock.h"
#import "WZDockItem.h"
#import "UIImage+WZ.h"

@interface WZDock()
{
    WZDockItem *_selelctDockItem;
}
@end

@implementation WZDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}
#pragma  mark 添加标签项
-(void)addItemWithIcon:(NSString *)icon selected:(NSString *)selectedIcon title:(NSString *)title 
{
    
    WZDockItem *item = [[WZDockItem alloc] init];//生成一个标签选项
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage apaterMyImage:icon] forState:UIControlStateNormal];
    //按钮被选中时的状态
    [item setImage:[UIImage apaterMyImage:selectedIcon] forState:UIControlStateSelected];
    //为按钮绑定事件
    [item addTarget:self action:@selector(clickMyItem:) forControlEvents:UIControlEventTouchDown];
    //将标签加入Dock
    [self addSubview:item];
   
    int count = self.subviews.count; // 获得所有控件的数量
    
    if( count == 1){//默认选中首页
        [self clickMyItem:item];
    }
         //设置选项卡的宽高
    CGFloat width = self.frame.size.width / count;
    CGFloat height = self.frame.size.height;
    
    for(int i = 0; i < count; i++){
        // 取得每一个按钮
        WZDockItem *dockItem = self.subviews[i];
        //设置按钮标记
        dockItem.tag = i;
        // 设置标签位置和选项
        dockItem.frame = CGRectMake(i * width, 0, width, height);
    }
    
}

#pragma mark 点击选项卡选项   切换试图和选项卡选中状态
-(void)clickMyItem:(WZDockItem *)item
{
    if([_delegate respondsToSelector:@selector(dock:itemSelectedFrom:to:)]){
        [_delegate dock:self itemSelectedFrom:_selelctDockItem.tag to:item.tag];
    }
    
    //将前一个按钮的状态设为未选中
    _selelctDockItem.selected = NO;
    //将按钮的状态设为选中
    item.selected  = YES;
    //将该按钮的状态设为选中
    _selelctDockItem = item;
  
}

@end

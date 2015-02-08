//
//  WZImagePage.h
//  保定小吃
//
//  Created by 王震 on 14-8-6.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyImageIndexDelegate

-(void)redirectContent:(NSInteger *) aid;

@end

@interface WZImagePage : UIView <UIScrollViewDelegate>

@property(assign,nonatomic)id<MyImageIndexDelegate> delegate;

@property (nonatomic,retain)NSMutableArray * listPics;//显示轮播图片
-(void) makeInit;
@end

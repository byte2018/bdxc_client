//
//  WZCustomTableViewCell.h
//  保定小吃
//
//  Created by 王震 on 14-8-11.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZPublishShow.h"
@class WZPublishShow;

@interface WZCustomTableViewCell : UITableViewCell

@property(nonatomic, strong) WZPublishShow *publicShow;//  小吃图片展示模型

- (CGFloat)addCustomStyle;

@end

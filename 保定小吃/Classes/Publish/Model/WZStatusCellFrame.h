//
//  WZStatusCellFrame.h
//  保定小吃
//
//  Created by 王震 on 14-8-20.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZCustomTableViewCell.h"


@interface WZStatusCellFrame : NSObject
//获得自己定义的Cell，并进行数据解析
-(WZPublishShow *)getMyPublicShow:(NSDictionary *)dic;
@end

//
//  WZStatusCellFrame.m
//  保定小吃
//
//  Created by 王震 on 14-8-20.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZStatusCellFrame.h"

@implementation WZStatusCellFrame


-(WZPublishShow *)getMyPublicShow:(NSDictionary *)dic
{
//    NSLog(@"%@", [dic objectForKey:@"UserIconUrl"]);
    //cell.textLabel.text = @"dsfasdfd";
    WZPublishShow * publicShow  = [[WZPublishShow alloc] init];
    publicShow.userIcon = [[dic objectForKey:@"user"] objectForKey:@"url"];
    
    publicShow.userName = [dic objectForKey:@"author"];
//    NSDate *now = [NSDate date];
//    //NSDateFormatter实现日期的输出
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    //[formatter setDateStyle:NSDateFormatterFullStyle];//直接输出的话是机器码
//    //或者是手动设置样式[formatter setDateFormat:@"yyyy-MM-dd"];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateString = [formatter stringFromDate:now];
//    NSLog(@"%@", dic);
    
    NSDate *  pubDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"dateline"] floatValue]];
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormtter stringFromDate:pubDate];
    //发布时间
    publicShow.pulishDate = dateString;
    
    //作品描述
    publicShow.textIntroduce = [dic objectForKey:@"message"];
    
    
    NSMutableArray * myFoodIcons = [dic objectForKey:@"publishPics"];
    
    publicShow.foodIcons = myFoodIcons;
    
    return publicShow;

}
@end

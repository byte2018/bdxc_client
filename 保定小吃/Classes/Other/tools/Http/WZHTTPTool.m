//
//  WZHTTPTool.m
//  保定小吃
//
//  Created by 王震 on 14-7-31.
//  Copyright (c) 2014年 javadonkey. All rights reserved.
//

#import "WZHTTPTool.h"
#import "NSString+WZURLEncoding.h"
#import "Reachability.h"


@interface WZHTTPTool()

@end
@implementation WZHTTPTool


#pragma  mark 获得get请求数据
-(NSDictionary *)httpGetJsonSynchronizedRequest:(NSString *)httpUrl params:(NSDictionary *)params
{
    NSMutableString *strurl = [[NSMutableString alloc ] initWithString:httpUrl];
    
    
    //NSLog(@"%d",params.count);
    
    //是否携带参数，如果携带则对参数进行拼装
    if(params.count){
        
        [strurl appendString:@"?"];
        for(id key in params){
            NSString *keyVlue = [NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]];
            [strurl appendString:keyVlue];
        }
            
        //对字符串进行截取，去掉&
        strurl = [strurl substringWithRange:NSMakeRange(0, strurl.length -1)];
        //NSLog(strurl);
    }

    
    NSURL *url = [NSURL URLWithString:[strurl URLEncodedString]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //NSLog(@"请求完成");
    
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //NSLog(@"%@", [resDict objectForKey:@"shortdescription" ]);
    
    return resDict;
}


#pragma mark - 上传单张图片
- (void)uploadImage:(NSString *)fullPath myPath:(NSString *) myPath hostName:(NSString *) hostName param: (NSMutableDictionary *)param myFileParam:(NSString *)myFileParam fileType:(NSString *)fileType
{
    _engine = [[MKNetworkEngine alloc] initWithHostName:hostName customHeaderFields:nil];
    
    MKNetworkOperation *op = [_engine operationWithPath:myPath params:param httpMethod:@"POST"];
    [op addFile:fullPath forKey:myFileParam mimeType:fileType];
    
    [op setFreezable:YES];
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        NSLog(@"上传完成");
        NSError *eror;
        NSData *data = [operation responseData];
        //NSLog(@"%@", data);
        if(data){
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&eror];
             [_delegate myReloadData:resDict]; //调用代理方法加载数据
        }
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err){
        NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
        
    }];
    [_engine enqueueOperation:op];
    //NSLog(@"%@", fullPath);
}


-(void)httpPostJsonRequest:(NSString *) hostName myPath:(NSString *) myPath param: (NSMutableDictionary *)param {
        _engine = [[MKNetworkEngine alloc] initWithHostName:hostName customHeaderFields:nil];
        
        MKNetworkOperation *op = [_engine operationWithPath:myPath params:param httpMethod:@"POST"];
        
        [op addCompletionHandler:^(MKNetworkOperation *operation){
            NSError *eror;
            NSData *data = [operation responseData];
           
            if(data){
                NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&eror];
                NSLog(@"%@", resDict);
                //调用代理方法切换试图 reloadData:resDict];
                [_delegate myReloadData:resDict]; //调用代理方法加载数据
            }
            
        } errorHandler:^(MKNetworkOperation *errorOp, NSError* err){
            NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
            
        }];
        [_engine enqueueOperation:op];

}



@end

//
//  DisiyeTwoStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/10.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DisiyeTwoStore.h"

@implementation DisiyeTwoStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://api.m.mtime.cn/PageSubArea/TrailerList.api" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSArray *arr = responseObject[@"ms"];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"trailers"];
        for (NSDictionary *dic1 in arr) {
            Disiye *si = [[Disiye alloc] init];
            si.title = dic1[@"movieName"];
            si.image = dic1[@"coverImg"];
            si.content = dic1[@"summary"];
            si.url = dic1[@"hightUrl"];
            [[DisiyeList sharedInstance].prevues1 addObject:si];
         }
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end

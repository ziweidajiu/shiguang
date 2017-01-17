//
//  DisiyeOneStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/10.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DisiyeOneStore.h"

@implementation DisiyeOneStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"pageIndex": self.number};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://api.m.mtime.cn/News/NewsList.api" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"newsList"];
        for (NSDictionary *dic1 in arr) {
            Disiye *si = [[Disiye alloc] init];
            if (dic1[@"images"] == nil) {
                si.title = dic1[@"title"];
                si.content = dic1[@"title2"];
                si.comment = [NSString stringWithFormat:@"评论 %@", dic1[@"commentCount"]];
                si.image = dic1[@"image"];
                [[DisiyeList sharedInstance].news1 addObject:si];
            } else {
                si.title = dic1[@"title"];
                si.image = dic1[@"image"];
                si.image = dic1[@"image"];
                si.comment = [NSString stringWithFormat:@"评论 %@", dic1[@"commentCount"]];
                NSArray *arr1 = dic1[@"images"];
                for (NSDictionary *dic2 in arr1) {
                    [si.images addObject:dic2[@"url1"]];
                }
                [[DisiyeList sharedInstance].news1 addObject:si];
            }
        }
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

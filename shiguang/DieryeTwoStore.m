//
//  DieryeTwoStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/9.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DieryeTwoStore.h"
#import <AFNetworking/AFNetworking.h>
#import "Model.h"

@implementation DieryeTwoStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://api.m.mtime.cn/Movie/MovieComingNew.api?locationId=290" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSArray *arr = responseObject[@"ms"];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"attention"];
        NSArray *arr1 = dic[@"moviecomings"];
        for (NSDictionary *dic in arr) {
            Dierye *mo = [[Dierye alloc] init];
            mo.title = dic[@"title"];
            mo.propleNum = [NSString stringWithFormat:@"%@", dic[@"wantedCount"]];
            mo.daoYan = dic[@"director"];
            mo.type = dic[@"type"];
            mo.image = dic[@"image"];
            mo.actor1 = dic[@"actor1"];
            mo.actor2 = dic[@"actor2"];
            [[DieryeList sharedInstance].movies3 addObject:mo];
        }
        for (NSDictionary *dic in arr1) {
            Dierye *mo = [[Dierye alloc] init];
            mo.title = dic[@"title"];
            mo.propleNum = [NSString stringWithFormat:@"%@", dic[@"wantedCount"]];
            mo.daoYan = dic[@"director"];
            mo.type = dic[@"type"];
            mo.image = dic[@"image"];
            [[DieryeList sharedInstance].movies2 addObject:mo];
        }
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end

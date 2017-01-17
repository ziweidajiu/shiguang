//
//  DieryeStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/4.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DieryeStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation DieryeStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"locationId":@"290"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://api.m.mtime.cn/Showtime/LocationMovies.api" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *arr = responseObject[@"ms"];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"ms"];
        for (NSDictionary *dic in arr) {
            Dierye *mo = [[Dierye alloc] init];
            mo.title = dic[@"t"];
            mo.content = dic[@"commonSpecial"];
            mo.time = dic[@"rd"];
            mo.cinama = [NSString stringWithFormat:@"%@", dic[@"NearestCinemaCount"]];
            mo.shows = [NSString stringWithFormat:@"%@", dic[@"NearestShowtimeCount"]];
            mo.ping = dic[@"r"];
            mo.type = dic[@"movieType"];
            mo.image = dic[@"img"];
            [[DieryeList sharedInstance].movies1 addObject:mo];
        }
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

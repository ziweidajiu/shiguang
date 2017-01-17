//
//  DisiyeThreeStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/11.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DisiyeThreeStore.h"

@implementation DisiyeThreeStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"pageIndex":self.number};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://api.m.mtime.cn/TopList/TopListOfAll.api" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"topLists"];
        for (NSDictionary *dic in arr) {
            Disiye *mo = [[Disiye alloc] init];
            mo.title = dic[@"topListNameCn"];
            [[DisiyeList sharedInstance].charts addObject:mo];
        }
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

@end

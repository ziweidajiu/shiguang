//
//  DisiyeFourStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/11.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DisiyeFourStore.h"

@implementation DisiyeFourStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://api.m.mtime.cn/MobileMovie/Review.api?needTop=false" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic1 in arr) {
            Disiye *si = [[Disiye alloc] init];
            si.title = dic1[@"title"];
            si.image = dic1[@"relatedObj"][@"image"];
            si.content = dic1[@"summary"];
            si.userImage = dic1[@"userImage"];
            si.userName = dic1[@"nickname"];
            si.comment = [NSString stringWithFormat:@"%@", dic1[@"rating"]];
            si.moviewName = dic1[@"relatedObj"][@"title"];
            [[DisiyeList sharedInstance].comments addObject:si];
        }
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

//
//  SignInStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "SignInStore.h"

@implementation SignInStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    __block NSError *responseError = nil;
    NSDictionary *paramrters = @{@"account":self.account,
                                 @"passwd":self.password.md5HexDigest
                                 };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://112.74.198.103:8080/user/sign_in" parameters:paramrters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        responseError = [BaseStore handleResponseError:responseObject];
        
        if (responseError == nil) {
            UserInfo *currentUser = [UserList userWithIdentity:responseObject[@"user_id"]];
            [UserList sharedInstance].currentUser = currentUser;
            currentUser.mobile = responseObject[@"user_mobile"];
            currentUser.email = responseObject[@"user_email"];
            currentUser.password = responseObject[@"user_passwd"];
            //        currentUser.gender = responseObject[@"user_gender"];
            currentUser.token = responseObject[@"user_token"];
            success();
        } else {
            failure(responseError);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

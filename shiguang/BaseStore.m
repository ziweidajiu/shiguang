//
//  BaseStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/4.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "BaseStore.h"

@implementation BaseStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSLog(@"!!!!!!!");
    abort();
}

+(NSError *)handleResponseError:(id)responseObject {
    if ([responseObject[@"code"] integerValue] == 0) {
        return nil;
    } else {
        NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:responseObject[@"message"],  NSLocalizedFailureReasonErrorKey:responseObject[@"message"]};
        NSError *responseError = [NSError errorWithDomain:responseObject[@"err_domain"] code:[responseObject[@"code"] integerValue] userInfo:errorUserInfo];
        return responseError;
    }
    
}

@end

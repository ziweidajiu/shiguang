//
//  BaseStore.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/4.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseStore : NSObject

-(void)requestWithSuccess:(void(^)())success failure:(void(^)(NSError *responseError))failure;

+(NSError *)handleResponseError:(id)responseObject;

@end

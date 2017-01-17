//
//  UserList.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "UserList.h"

@implementation UserList

+(instancetype)sharedInstance {
    static UserList *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[UserList alloc] init];
    });
    return sharedClient;
}

+(UserInfo *)userWithIdentity:(NSString *)identity {
    NSArray *filteredUsers = [[UserList sharedInstance].users filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UserInfo * evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.identity isEqualToString:identity];
    }]];
    
    NSAssert(filteredUsers.count <=1, @"查询到了相同的用户");
    
    if (filteredUsers.count == 1) {
        return [filteredUsers firstObject];
    } else {
        UserInfo *result = [[UserInfo alloc] init];
        result.identity = identity;
        [[UserList sharedInstance].users addObject:result];
        return result;
    }
    
}

@end

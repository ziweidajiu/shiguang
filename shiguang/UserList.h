//
//  UserList.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserList : NSObject

@property (nonatomic, strong) UserInfo *currentUser;

@property (nonatomic, strong) NSMutableArray *users;

+(instancetype)sharedInstance;

+(UserInfo *)userWithIdentity:(NSString *)identity;

@end

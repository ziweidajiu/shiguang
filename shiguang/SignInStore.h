//
//  SignInStore.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "BaseStore.h"

@interface SignInStore : BaseStore

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *password;

@end

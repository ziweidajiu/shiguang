//
//  SignUpStore.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "BaseStore.h"

@interface SignUpStore : BaseStore

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (assign, nonatomic) kGender gender;

@end

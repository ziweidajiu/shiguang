//
//  UserInfo.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kGender) {
    kGenderUnknown,
    kGenderMale,
    kGenderFemale
};

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *identity;

@property (nonatomic, copy) NSString *token;

@property (assign, nonatomic) kGender gender;

@end

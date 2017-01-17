//
//  DieryeList.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/4.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dierye;
@interface DieryeList : NSObject

@property (nonatomic, strong) NSMutableArray *movies1;

@property (nonatomic, strong) NSMutableArray *movies2;

@property (nonatomic, strong) NSMutableArray *movies3;

+(instancetype)sharedInstance;

@end

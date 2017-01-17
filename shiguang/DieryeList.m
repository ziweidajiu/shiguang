//
//  DieryeList.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/4.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DieryeList.h"

@implementation DieryeList

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.movies1 = [NSMutableArray array];
        self.movies2 = [NSMutableArray array];
        self.movies3 = [NSMutableArray array];
    }
    return self;
}

+(instancetype)sharedInstance {
    static DieryeList *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[DieryeList alloc] init];
    });
    
    return sharedClient;
}

@end

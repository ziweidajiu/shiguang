//
//  DisiyeList.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/10.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DisiyeList.h"

@implementation DisiyeList

- (instancetype)init
{
    if (self = [super init]) {
        self.news1 = [NSMutableArray array];
        self.prevues1 = [NSMutableArray array];
        self.comments = [NSMutableArray array];
        self.charts = [NSMutableArray array];
    }
    return self;
}

+(instancetype)sharedInstance {
    static DisiyeList *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[DisiyeList alloc] init];
    });
    return sharedClient;
}

@end

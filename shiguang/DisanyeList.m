//
//  DisanyeList.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DisanyeList.h"

@implementation DisanyeList

- (instancetype)init
{
    if (self = [super init]) {
        self.scrollViews = [NSMutableArray array];
        self.navigatorIcons = [NSMutableArray array];
        self.cells = [NSMutableArray array];
        self.topics = [NSMutableArray array];
        self.categorys = [NSMutableArray array];
    }
    return self;
}

+(instancetype)sharedInstance {
    static DisanyeList *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[DisanyeList alloc] init];
    });
    return sharedClient;
}

@end

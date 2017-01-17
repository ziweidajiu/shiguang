//
//  DisiyeList.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/10.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisiyeList : NSObject

@property (nonatomic, strong) NSMutableArray *news1;
@property (nonatomic, strong) NSMutableArray *prevues1;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *charts;

+(instancetype)sharedInstance;

@end

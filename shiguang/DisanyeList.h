//
//  DisanyeList.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisanyeList : NSObject

@property (nonatomic, strong) NSMutableArray *scrollViews;

@property (nonatomic, strong) NSMutableArray *navigatorIcons;

@property (nonatomic, strong) NSMutableArray *cells;

@property (nonatomic, strong) NSMutableArray *topics;

@property (nonatomic, strong) NSMutableArray *categorys;

+(instancetype)sharedInstance;

@end

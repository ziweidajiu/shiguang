//
//  Disiye.h
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/10.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Disiye : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *moviewName;

@end

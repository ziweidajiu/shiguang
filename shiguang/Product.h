//
//  Product.h
//  ZhiFu
//
//  Created by 紫薇大舅 on 16/5/11.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end


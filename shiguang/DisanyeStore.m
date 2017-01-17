//
//  DisanyeStore.m
//  shiguang
//
//  Created by 紫薇大舅 on 16/5/12.
//  Copyright © 2016年 ziweidajiu. All rights reserved.
//

#import "DisanyeStore.h"

@implementation DisanyeStore

-(void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://mall.wv.mtime.cn/Service/callback.mi/PageSubArea/MarketFirstPageNew.api?t=201510120295722784" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"scrollImg"];
        for (NSDictionary *dic1 in arr) {
            Disanye *mo = [[Disanye alloc] init];
            mo.image1 = dic1[@"image"];
            mo.url1 = dic1[@"url"];
            [[DisanyeList sharedInstance].scrollViews addObject:mo];
        }
        NSArray *arr2 = dic[@"navigatorIcon"];
        for (NSDictionary *dic2 in arr2) {
            Disanye *mo = [[Disanye alloc] init];
            mo.url1 = [NSString stringWithFormat:@"http://mall.wv.mtime.cn/%@", dic2[@"url"]];
            mo.title = dic2[@"iconTitle"];
            mo.image1 = dic2[@"image"];
            [[DisanyeList sharedInstance].navigatorIcons addObject:mo];
        }
        Disanye *mo1 = [[Disanye alloc] init];
        mo1.image1 = dic[@"cellA"][@"img"];
        mo1.url1 = dic[@"cellA"][@"url"];
        mo1.url2 = dic[@"cellC"][@"list"][0][@"url"];
        mo1.image2 = dic[@"cellC"][@"list"][0][@"image"];
        mo1.image3 = dic[@"cellC"][@"list"][1][@"image"];
        mo1.url3 = dic[@"cellC"][@"list"][1][@"url"];
        [[DisanyeList sharedInstance].cells addObject:mo1];
        Disanye *mo2 = [[Disanye alloc] init];
        mo2.image1 = dic[@"cellB"][@"img"];
        mo2.url1 = dic[@"cellB"][@"url"];
        [[DisanyeList sharedInstance].cells addObject:mo2];
        NSArray *arr3 = dic[@"topic"];
        for (NSDictionary *dic3 in arr3) {
            Disanye *mo = [[Disanye alloc] init];
            mo.title = dic3[@"titleCn"];
            mo.title2 = dic3[@"titleEn"];
            mo.image1 = dic3[@"checkedImage"];
            mo.image2 = dic3[@"uncheckImage"];
            mo.image3 = dic3[@"backgroupImage"];
            mo.url1 = dic3[@"url"];
            NSArray *arr4 = dic3[@"subList"];
            for (NSDictionary *dic4 in arr4) {
                Disanye *mo1 = [[Disanye alloc] init];
                mo1.title = dic4[@"title"];
                mo1.image1 = dic4[@"image"];
                [mo.commonArr addObject:mo1];
            }
            [[DisanyeList sharedInstance].topics addObject:mo];
        }
        NSArray *arr5 = dic[@"category"];
        for (NSDictionary *dic5 in arr5) {
            Disanye *mo = [[Disanye alloc] init];
            mo.title = dic5[@"name"];
            mo.image1 = dic5[@"image"];
            mo.url1 = dic5[@"imageUrl"];
            mo.url2 = dic5[@"moreUrl"];
            NSArray *arr6 = dic5[@"subList"];
            for (NSDictionary *dic6 in arr6) {
                Disanye *mo1 = [[Disanye alloc] init];
                mo1.title = dic6[@"title"];
                mo1.image1 = dic6[@"image"];
                [mo.commonArr addObject:mo1];
            }
            [[DisanyeList sharedInstance].categorys addObject:mo];
        }
        
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

@end

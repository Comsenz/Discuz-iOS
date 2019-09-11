//
//  RecommendModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/9/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel


+ (NSArray *)setRecommendData:(id)responseObject {
    NSMutableArray *hotArr = [NSMutableArray array];
    NSArray *recommonthread_list = [[responseObject objectForKey:@"Variables"] objectForKey:@"recommonthread_list"];
    if ([DataCheck isValidArray:recommonthread_list]) {
        
        NSMutableDictionary *gropDic = [NSMutableDictionary dictionary];
        NSDictionary *groupiconid = [[responseObject objectForKey:@"Variables"] objectForKey:@"groupiconid"];
        if ([DataCheck isValidDictionary:groupiconid]) {
            gropDic = groupiconid.mutableCopy;
        }
        
        for (NSDictionary *dic in recommonthread_list) {
            RecommendModel *home = [[RecommendModel alloc] init];
            [home setValuesForKeysWithDictionary:dic];
            if ([DataCheck isValidDictionary:gropDic]) {
                home.grouptitle = [gropDic objectForKey:home.authorid];
            }
            
            [hotArr addObject:home];
        }
        
    }
    return hotArr;
}

@end

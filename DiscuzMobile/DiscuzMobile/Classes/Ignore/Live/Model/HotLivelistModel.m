//
//  HotLivelistModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "HotLivelistModel.h"

@implementation HotLivelistModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"imagelist"]) {
        if ([DataCheck isValidDictionary:value]) {
            _liveIcon = [value objectForKey:@"src"];
        }
    }
}

+ (NSArray *)setHotLiveData:(id)responseObject {
    
    return [HotLivelistModel setData:responseObject andKeystr:@"livethread_list"];
}

+ (NSArray *)setRecommonLiveData:(id)responseObject {
    
    return [HotLivelistModel setData:responseObject andKeystr:@"recommonthread_list"];
    
}

+ (NSArray *)setData:(id)responseObject andKeystr:(NSString *)keyStr {
    NSMutableArray *dataArr = [NSMutableArray array];
    
    NSMutableDictionary *gropDic = [NSMutableDictionary dictionary];
    if ([DataCheck isValidDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"groupiconid"]]) {
        gropDic = [NSMutableDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"groupiconid"]];
    }
    
    if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:keyStr]]) {
        NSArray *arr = [[responseObject objectForKey:@"Variables"] objectForKey:keyStr];
        for (NSDictionary *dic in arr) {
            HotLivelistModel *model = [[HotLivelistModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if ([DataCheck isValidDictionary:gropDic]) {
                model.grouptitle = [gropDic objectForKey:model.authorid];
            }
            [dataArr addObject:model];
        }
    }
    return dataArr;
}



@end

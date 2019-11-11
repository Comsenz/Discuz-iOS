//
//  DZHomeBannerModel.m
//  DiscuzMobile
//
//  Created by HB on 16/4/18.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import "DZHomeBannerModel.h"

@implementation DZHomeBannerModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSArray *)setBannerData:(id)responseObject {
    NSMutableArray *bannerArr = [NSMutableArray array];
    if ([DataCheck isValidArray:[[responseObject objectForKey:@"iweset"] objectForKey:@"recommend"]]) {
        
        for (NSDictionary *dic in [[responseObject objectForKey:@"iweset"] objectForKey:@"recommend"]) {
            DZHomeBannerModel *banner = [[DZHomeBannerModel alloc] init];
            [banner setValuesForKeysWithDictionary:dic];
            [bannerArr addObject:banner];
        }
        
    }
    return bannerArr;
}

@end

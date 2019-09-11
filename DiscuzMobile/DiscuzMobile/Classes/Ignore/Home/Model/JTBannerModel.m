//
//  JTBannerModel.m
//  DiscuzMobile
//
//  Created by HB on 16/4/18.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "JTBannerModel.h"

@implementation JTBannerModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSArray *)setBannerData:(id)responseObject {
    NSMutableArray *bannerArr = [NSMutableArray array];
    if ([DataCheck isValidArray:[[responseObject objectForKey:@"iweset"] objectForKey:@"recommend"]]) {
        
        for (NSDictionary *dic in [[responseObject objectForKey:@"iweset"] objectForKey:@"recommend"]) {
            JTBannerModel *banner = [[JTBannerModel alloc] init];
            [banner setValuesForKeysWithDictionary:dic];
            [bannerArr addObject:banner];
        }
        
    }
    return bannerArr;
}

@end

//
//  ForumInfoModel.m
//  DiscuzMobile
//
//  Created by HB on 16/12/21.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "ForumInfoModel.h"

@implementation ForumInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _fid = value;
    }
    else if ([key isEqualToString:@"lastpost"]) {
        if ([DataCheck isValidDictionary:value]) {
            _lastpost = [[value objectForKey:@"dateline"] transformationStr];
        } else {
            [super setValue:value forKey:key];
        }
    }
    else if ([key isEqualToString:@"favorite"]) {
        _favorited = value;
    }
    else {
        if ([@[@"todayposts",@"threads",@"posts"] containsObject:key]) {
            value = [value onePointCountWithNumstring];
        } else if ([@[@"name",@"description"] containsObject:key]) {
            value = [[value transformationStr] flattenHTMLTrimWhiteSpace:YES];
            if ([key isEqualToString:@"description"]) {
                _descrip = value;
            }
        }
        [super setValue:value forKey:key];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"fid:%@，版块名：%@",_fid,_name];
}


@end

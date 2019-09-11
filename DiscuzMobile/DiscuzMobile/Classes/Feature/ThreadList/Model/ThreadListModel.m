//
//  ThreadListModel.m
//  DiscuzMobile
//
//  Created by HB on 17/1/18.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ThreadListModel.h"
#import "DZAttachment.h"

@implementation ThreadListModel

MJCodingImplementation

+ (void)initialize
{
    if (self == [ThreadListModel class]) {
        [ThreadListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"typeId":@"typeid"};
        }];
        [ThreadListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"attachlist":@"DZAttachment"};
        }];
    }
}

- (instancetype)init {
    if ([super init]) {
        self.imglist = [NSMutableArray array];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"attachlist"]) {
        for (DZAttachment *attItem in value) {
            if ([DataCheck isValidString:attItem.type]) {
                if ([attItem.type isEqualToString:@"image"]) {
                    [self.imglist addObject:attItem.thumb];
                }
            }
        }
        return;
    }
    
    if ([@[@"views",@"replies",@"recommend_add"] containsObject:key]) {
        value = [value onePointCountWithNumstring];
    } else if ([key isEqualToString:@"dateline"]) {
        NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([value rangeOfCharacterFromSet:notDigits].location == NSNotFound) { // 是数字
            value = [NSDate timeStringFromTimestamp:value format:@"yyyy-MM-dd"];
        }
    } else if ([key isEqualToString:@"typeid"]) {
        _typeId = value;
    }
    
    if ([@[@"subject",@"message",@"dateline"] containsObject:key]) {
        value = [value transformationStr];
    }
    
    if ([key isEqualToString:@"subject"]) {
        _useSubject = value;
    }
    
    [super setValue:value forKey:key];
}

// 特殊帖判断
- (BOOL)isSpecialThread {
    NSArray *specialArr = @[@"1",@"4",@"5"];
    if ([DataCheck isValidString:self.special]) {
        if ([specialArr containsObject:self.special]) {
            return YES;
        }
    }
    return NO;
}

// 置顶帖判断
- (BOOL)isTopThread {
    NSArray *topCheckArray = @[@"1",@"2",@"3"];
    if ([topCheckArray containsObject:self.displayorder]) {
        return YES;
    }
    return false;
}


+ (NSDictionary *)getTypeDic:(id)responseObject {
    NSMutableDictionary *typeDic = [NSMutableDictionary dictionary];
    NSDictionary *threadtypes = [[responseObject objectForKey:@"Variables"] objectForKey:@"threadtypes"];
    if ([DataCheck isValidDictionary:threadtypes]) {
        NSDictionary *types = [threadtypes objectForKey:@"types"];
        if ([DataCheck isValidDictionary:types]) {
            typeDic = [NSMutableDictionary dictionaryWithDictionary:types];
        }
    }
    return typeDic;
}

+ (NSDictionary *)getGroupDic:(id)responseObject {
    NSMutableDictionary *gropDic = [NSMutableDictionary dictionary];
    NSDictionary *groupiconid = [[responseObject objectForKey:@"Variables"] objectForKey:@"groupiconid"];
    if ([DataCheck isValidDictionary:groupiconid]) {
        gropDic = [NSMutableDictionary dictionaryWithDictionary:groupiconid];
    }
    return gropDic;
}

#pragma mark - 重写settter方法 过滤标签
- (void)setGrouptitle:(NSString *)grouptitle {
    if ([DataCheck isValidString:grouptitle]) {
        _grouptitle = [grouptitle flattenHTMLTrimWhiteSpace:YES];
    }
}

- (void)setTypeName:(NSString *)typeName {
    if ([DataCheck isValidString:typeName]) {
        _typeName = [typeName flattenHTMLTrimWhiteSpace:YES];
    }
}

@end

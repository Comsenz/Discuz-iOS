//
//  DataCheck.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/7.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "DataCheck.h"
#import "LiveDetailModel.h"

@implementation DataCheck
//判断是否 有效 或者 是健全的 数组 字典 字符串 
+ (BOOL) isValidString:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSString class]]) {
        return NO;
    }
    if ([input isEqualToString:@"(null)"]) {
        return NO;
    }
    if ([input isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) isValidDictionary:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    if ([input count] <= 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) isValidArray:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if ([input count] <= 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)arrayA:(NSArray *)arrayA isEqualArrayB:(NSArray *)arrayB {
    if (![DataCheck isValidArray:arrayA] || ![DataCheck isValidArray:arrayB]) {
        return NO;
    }
    if (arrayA.count != arrayB.count) {
        return NO;
    }
    for (NSInteger i = 0; i < arrayA.count; i++ ) {
        if ([arrayA[i] isKindOfClass:[LiveDetailModel class]] && [arrayB[i] isKindOfClass:[LiveDetailModel class]]) {
            LiveDetailModel *A = arrayA[i];
            LiveDetailModel *B = arrayB[i];
            if (![A.dbdateline isEqualToString:B.dbdateline]) {
                return NO;
            }
        } else {
            return NO;
        }
        
    }
    
    return YES;
}


@end

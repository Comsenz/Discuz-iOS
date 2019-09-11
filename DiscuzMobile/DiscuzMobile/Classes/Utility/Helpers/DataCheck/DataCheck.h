//
//  DataCheck.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/7.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCheck : NSObject

+ (BOOL) isValidString:(id)input;
+ (BOOL) isValidDictionary:(id)input;
+ (BOOL) isValidArray:(id)input;
+ (BOOL)arrayA:(NSArray *)arrayA isEqualArrayB:(NSArray *)arrayB;

@end

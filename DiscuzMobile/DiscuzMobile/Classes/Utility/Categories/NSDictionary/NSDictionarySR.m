//
//  NSDictionarySR.m
//  Discuz2
//
//  Created by rexshi on 9/27/11.
//  Copyright 2011 rexshi. All rights reserved.
//

#import "NSDictionarySR.h"

@implementation NSDictionary (SR)

- (NSArray *)sortedKeyInDesc:(BOOL)desc
{
    NSArray *allKeys = [self allKeys];
    
    NSArray *sortedAllKeys = nil;
    if (desc == YES) {
        sortedAllKeys = [allKeys sortedArrayUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 intValue] > [obj2 intValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([obj1 intValue] < [obj2 intValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
    } else {
        sortedAllKeys = [allKeys sortedArrayUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 intValue] > [obj2 intValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 intValue] < [obj2 intValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
    }
    
    return sortedAllKeys;
}

- (NSArray *)sortedValueByKeyInDesc:(BOOL)desc
{    
    NSArray *sortedAllKeys = [self sortedKeyInDesc:desc];

    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *key in sortedAllKeys) {
        [newArray addObject:[self objectForKey:key]];
    }
    
    return newArray;
}

@end

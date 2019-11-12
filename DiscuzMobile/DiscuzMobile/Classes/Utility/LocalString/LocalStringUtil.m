//
//  LocalStringUtil.m
//  PandaReader
//
//  Created by WebersonGao on 2019/2/28.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "LocalStringUtil.h"

@implementation LocalStringUtil

+ (NSString *)localString:(NSString *)string
{
//   return [[NSBundle mainBundle] localizedStringForKey:string value:string table:@"Localizable"]
    return string;
}
@end

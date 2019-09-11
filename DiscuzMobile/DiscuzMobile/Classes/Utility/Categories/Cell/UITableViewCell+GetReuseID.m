//
//  UITableViewCell+GetReuseID.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/10.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "UITableViewCell+GetReuseID.h"

@implementation UITableViewCell (GetReuseID)
+ (NSString *)getReuseId {
    return NSStringFromClass([self class]);
}
@end

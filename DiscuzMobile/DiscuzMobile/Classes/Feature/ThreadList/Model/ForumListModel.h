//
//  ForumListModel.h
//  DiscuzMobile
//
//  Created by HB on 17/1/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumListModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *fid;

- (instancetype)initWithName:(NSString *)name andWithFid:(NSString *)fid;

+ (instancetype)initWithName:(NSString *)name andWithFid:(NSString *)fid;

@end

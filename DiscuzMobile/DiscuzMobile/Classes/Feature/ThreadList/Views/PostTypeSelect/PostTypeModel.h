//
//  PostTypeModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, PostType) {
    post_normal,
    post_vote,
    post_activity,
    post_debate,
};

@interface PostTypeModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) PostType type;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName type:(PostType)type;

+ (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName type:(PostType)type;


@end

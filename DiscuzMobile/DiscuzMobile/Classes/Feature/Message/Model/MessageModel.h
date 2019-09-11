//
//  MessageModel.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/7/6.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

//typedef enum {
//    
//    kMessageModelTypeOther,
//    kMessageModelTypeMe
//    
//} MessageModelType;

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, strong) NSString *touid;
@property (nonatomic, strong) NSString *plid;
@property (nonatomic, strong) NSString *pmid;
@property (nonatomic, strong) NSString *fromavatar;
@property (nonatomic, strong) NSString *toavatar;

@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) YYTextLayout *textLayout; //文本
@property (nonatomic, strong) NSAttributedString *commentAttributeText;

+ (id)messageModelWithDict:(NSDictionary *)dict;

@end

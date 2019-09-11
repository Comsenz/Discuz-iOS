//
//  JTBannerModel.h
//  DiscuzMobile
//
//  Created by HB on 16/4/18.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTBannerModel : NSObject

@property (nonatomic, strong) NSString *imagefile; // 图片路径 有的时候优先取
@property (nonatomic,strong) NSString *imageurl;  // 图片路径
@property (nonatomic,strong) NSString *link;    // 点击图片链接
@property (nonatomic,strong) NSString *title;  // 标题
@property (nonatomic,strong) NSString *tid;    // 帖子tid
@property (nonatomic, strong) NSString *link_type;

+ (NSArray *)setBannerData:(id)responseObject;

@end

//
//  PostTypeSelectView.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFloatingView.h"
#import "PostTypeModel.h"
//typedef NS_ENUM(NSUInteger, PostType) {
//    post_normal,
//    post_vote,
//    post_activity,
//    post_debate,
//};

typedef void(^SelectTypeBlock)(PostType type);

@interface PostTypeSelectView : BaseFloatingView

@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, strong) UITableView *selectTableView;

@property (nonatomic, copy) SelectTypeBlock typeBlock;

//- (void)setAllowpost:(NSString *)allowpostspecial;

- (void)setPostType:(NSString *)poll activity:(NSString *)activity debate:(NSString *)debate allowspecialonly:(NSString *)allowspecialonly allowpost:(NSString *)allowpost;

//- (void)setPostType:(NSString *)poll andActivity:(NSString *)activity andDebate:(NSString *)debate;


@end

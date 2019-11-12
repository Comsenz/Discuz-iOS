//
//  TPBaseNavigationBarViewController.h
//  PandaReader
//
//  Created by WebersonGao on 2019/4/4.
//  Copyright © 2019 ZHWenXue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPNavigationBar.h"

typedef NS_ENUM(NSInteger, TPNavigationItemType) {
    TPNavigationItemType_None,
    TPNavigationItemType_Text,//文本
    TPNavigationItemType_Image//图片
};

NS_ASSUME_NONNULL_BEGIN

@interface TPBaseNavigationBarViewController : UIViewController

/** 控制共用的NavigationBar 可直接Hidden隐藏 */
@property(nonatomic,strong) TPNavigationBar *tp_NavigationBar;
/** NavigationBar 上的 NavigationItem 导航条目 接收左右的item */
@property(nonatomic,strong) UINavigationItem *tp_NavigationItem;

/** 导航栏隐藏 */
@property(nonatomic,assign) BOOL isHiddenNavigationBar;
/** 导航栏透明度 */
@property(nonatomic,assign) CGFloat tp_NavigationAlpha;

/** 导航条的颜色 */
@property(nonatomic,strong) UIColor *tp_BarTintColor;
/** 导航大标题的颜色 */
@property(nonatomic,strong) UIColor *tp_BarTitleTextColor;
/** 导航标题的字号 */
@property(nonatomic,strong) UIFont *tp_BarTitleFont;

/** 是否覆盖vc的title默认是NO,使用自定义title */
@property(nonatomic,assign) BOOL normalTitle;


/**
 设置Item
 
 @param infoStr 图片名/文本
 @param type 图片/文本
 @param isLeft 是左/右 左=YES
 @param isFix 是否需要弹簧
 @param target 代理
 @param action 点击事件
 */
- (void)tp_SetNavigationItemWithInfoString:(NSString *)infoStr Type:(TPNavigationItemType)type Layout:(BOOL)isLeft FixSpace:(BOOL)isFix target:(id)target action:(SEL)action;

/**
 设置返回item
 
 @param target 代理
 @param action 事件
 */
- (void)tp_SetNavigationBackItemWithTarget:(id)target action:(SEL)action;

/**
 设置右上角文本item
 
 @param infoStr 文本
 @param target 代理
 @param action 事件
 */
- (void)tp_SetNavigationRightTextItemWithInfoString:(NSString *)infoStr target:(id)target action:(SEL)action;
/**
 设置items
 
 @param items items
 @param isLeft 是否是左边
 */
- (void)tp_SetItems:(NSArray *)items Layout:(BOOL)isLeft;

/**
 *设置标题视图
 
 @param titleView 自定义视图
 */
- (void)tp_SetNavigationTitleView:(UIView *)titleView;

/**
 取消滚动视图的缩进
 
 @param tableview 滚动视图
 */
- (void)tp_CancelScrollViewInsetWithTableView:(UITableView *)tableview;

/**
 将子View 放在Bar之下还是之上
 
 @param view 子view
 @param isBelow BOOL
 */
- (void)tp_AddSubView:(UIView *)view belowNavigationBar:(BOOL)isBelow;

/**
 点击返回按钮 子类可以通过拦截这个方法拦截返回事件
 */
- (void)tp_BaseControllerClickBackItem;


@end

NS_ASSUME_NONNULL_END

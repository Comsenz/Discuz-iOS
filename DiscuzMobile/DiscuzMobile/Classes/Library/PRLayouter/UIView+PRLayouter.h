//
//  UIView+PRLayouter.h
//  PandaReader
//
//  Created by changle on 2017/11/9.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PRLayouter)

/**
 全版本适用的addtionalSafeAreaInsets
 */
@property (nonatomic, assign) UIEdgeInsets pr_additionalSafeAreaInsets;


/**
 参照呈现尺寸缩放安全区(面向设计尺寸布局专用)
 */
@property (nonatomic, assign, readonly) UIEdgeInsets pr_scaledAdditionalSafeAreaInsets;


@end


@interface UIView (PRLayouter)


/**
 全版本适用的safeAreaInsets
 */
@property (nonatomic, assign, readonly) UIEdgeInsets pr_safeAreaInsets;


/**
 参照呈现尺寸来缩放安全区(面向设计尺寸布局专用)
 */
@property (nonatomic, assign, readonly) UIEdgeInsets pr_scaledSafeAreaInsets;


/**
 全版本适用的safeArea
 */
@property (nonatomic, assign, readonly) CGRect pr_safeArea;

/**
 参照呈现尺寸来缩放安全区(面向设计尺寸布局专用)
 */
@property (nonatomic, assign, readonly) CGRect pr_scaledSafeArea;


/**
 判断view是否全屏显示，包括自身scale，乃至某个祖先视图scale的情况(支持面向设计尺寸布局)
 */
@property (nonatomic, assign, readonly) BOOL pr_isFullScreen;


@end

@interface UIScrollView (PRLayouter)


/**
 iOS11以前，自动根据自身safeAreaInsets调整contentInsets
 */
- (void)pr_autoAdjustContentInsetsScrollsToTop:(BOOL)scrollsToTop;

@end



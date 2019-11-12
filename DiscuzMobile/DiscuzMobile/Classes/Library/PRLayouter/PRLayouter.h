//
//  PRLayouter.h
//  PandaReader
//
//  Created by changle on 2017/11/9.
//

#import "UIView+PRLayouter.h"

FOUNDATION_EXTERN const CGSize PRLayouterDesignedSizeForPhonePortrait;
FOUNDATION_EXTERN const CGSize PRLayouterDesignedSizeForPadPortrait;

@interface PRLayouter : NSObject

+ (PRLayouter *)sharedLayouter;

- (instancetype)initWithPortraitPhoneSize:(CGSize)portraitPhoneSize portraitPadSize:(CGSize)portraitPadSize;

@property (nonatomic, assign, readonly) CGRect designSize;
@property (nonatomic, assign, readonly) CGRect realSize;

@property (nonatomic, assign, readonly) CGFloat scale;

- (void)adjustFullView:(UIView *)view;
- (void)adjustFullViewForManualLayoutSubviews:(UIView *)view layoutSubviewsBlock:(void (^)(CGRect))block;

#pragma mark - class methods
+ (BOOL)isPhone;
+ (BOOL)isPad;
+ (BOOL)isPortrait;
+ (CGFloat)systemVersion;

+ (CGRect)screenFrame;
+ (CGFloat)width;
+ (CGFloat)height;

+ (CGFloat)deviceWidth;
+ (CGFloat)deviceHeight;

+ (CGRect)designSize;
+ (CGFloat)designWidth;
+ (CGFloat)designHeight;

+ (CGFloat)statusBarHeight;

// 竖屏设计尺寸，线程安全，用于子线程计算布局
+ (CGFloat)designWidthPortrait;

+ (CGRect)realSize;
+ (CGFloat)scale;

+ (void)clearAllAdjustForView:(UIView *)view;

+ (void)adjustFullView:(UIView *)view;
+ (void)adjustFullViewForManualLayoutSubviews:(UIView *)view layoutSubviewsBlock:(void (^)(CGRect))block;
+ (void)adjustView:(UIView *)view withDesignedSize:(CGSize)designedSize presentedSize:(CGRect)presentedSize;
+ (void)adjustViewForAutoresizing:(UIView *)view withPresentedSize:(CGRect)presentedSize;
+ (void)adjustViewForManualLayoutSubviews:(UIView *)view withDesignedSize:(CGSize)designedSize presentedSize:(CGRect)presentedSize layoutSubviewsBlock:(void (^)(CGRect))block;


#pragma mark About: Device Safe Area Insets In Step Initialize
+ (BOOL)is_iPhoneX;

+ (CGFloat)navigation_Bar_Height;

+ (CGFloat)navigation_Bar_ContainStatusBar_Height;

+ (CGFloat)navigation_Bar_Gap_X;

+ (CGFloat)navigation_Bar_Gap_2X;

+ (CGFloat)navigation_Bar_Height_Portrait;

+ (CGFloat)navigation_Bar_ContainStatusBar_Height_Portrait;

+ (CGFloat)navigation_Bar_Gap_X_Portrait;

+ (CGFloat)navigation_Bar_Gap_2X_Portrait;

+ (CGFloat)tabbar_Height;

+ (CGFloat)tabbar_Gap_2X;

+ (CGFloat)bottom_Height_X;

+ (CGFloat)left_Gap_X;

+ (CGFloat)right_Gap_X;

+ (CGFloat)tabbar_Gap_X;



@end

//
//  PRLayouter.m
//  PandaReader
//
//  Created by changle on 2017/11/9.
//

#import "PRLayouter.h"
#import "UIView+PRLayouter.h"
#import <sys/utsname.h>

const CGSize PRLayouterDesignedSizeForPhonePortrait = (CGSize){375, 667};
const CGSize PRLayouterDesignedSizeForPadPortrait = (CGSize){768, 1024};

@interface PRLayouter ()

@property (nonatomic, assign) BOOL isPhone;
@property (nonatomic, assign) BOOL isPad;
@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, assign) BOOL isIphoneX;
@property (nonatomic, assign) CGFloat systemVersion;

@property (nonatomic, assign) CGRect screenFrame;
@property (nonatomic, assign) CGFloat width; // 屏幕宽(包含界面旋转)
@property (nonatomic, assign) CGFloat height; // 屏幕高
@property (nonatomic, assign, readonly) CGFloat statusBarHeight; // 状态条高

@property (nonatomic, assign, readonly) CGFloat deviceW; // 设备宽(无视屏幕旋转)
@property (nonatomic, assign, readonly) CGFloat deviceH; // 设备高

@property (nonatomic, assign, readonly) CGSize portraitPhoneSize;
@property (nonatomic, assign, readonly) CGSize portraitPadSize;

@property (nonatomic, assign) CGFloat designWidthPortrait;

/*
 PS. 原本只需要一个safeAreaInsets即可，之所以用这么多属性表示设备的屏幕安全区：
 1. 导航栏特殊，因此需要navHeight, navHeightContainsStatusBar, navGapX/2X
 2. UI初始化阶段布局完毕，而不是在布局阶段调整，因此横屏切竖屏时，还没来得及转屏就已经布局完毕，因此需要XXXForcePortrait
 
 */
@property (nonatomic, assign) CGFloat screenSafeInsetsTop;
@property (nonatomic, assign) CGFloat screenSafeInsetsBottom;
@property (nonatomic, assign) CGFloat screenSafeInsetsLeft;
@property (nonatomic, assign) CGFloat screenSafeInsetsRight;

@property (nonatomic, assign) CGFloat pandaReaderNavigationHeight;
@property (nonatomic, assign) CGFloat pandaReaderNavigationHeightContainsStatusBar;
// 正常导航栏应该是20 + 44与44 + 44；而PandaReader是20 + 44与20 + 68；因此导航栏内部控件的偏移量，应该是(44 - 20) = 24
@property (nonatomic, assign) CGFloat pandaReaderNavigationGap2X;
@property (nonatomic, assign) CGFloat pandaReaderNavigationGapX;

// 强制竖屏版
@property (nonatomic, assign) CGFloat pandaReaderNavigationHeightForcePortrait;
@property (nonatomic, assign) CGFloat pandaReaderNavigationHeightContainsStatusBarForcePortrait;
@property (nonatomic, assign) CGFloat pandaReaderNavigationGap2XForcePortrait;
@property (nonatomic, assign) CGFloat pandaReaderNavigationGapXForcePortrait;

@property (nonatomic, assign) CGFloat pandaReaderTabBarHeight;
// 仅仅避过homeBar，而不用避过圆角
@property (nonatomic, assign) CGFloat pandaReaderBottomBarHeight;

// 刚好避过底部home bar的合适区域(即横屏的safeAreaInsets.bottom)
@property (nonatomic, assign) CGFloat screenBottomGap;


@end

@implementation PRLayouter

static PRLayouter *_instance = nil;
+ (PRLayouter *)sharedLayouter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PRLayouter alloc] init];
    });
    return _instance;
}

- (instancetype)initWithPortraitPhoneSize:(CGSize)portraitPhoneSize portraitPadSize:(CGSize)portraitPadSize
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        _portraitPhoneSize = portraitPhoneSize;
        _portraitPadSize = portraitPadSize;
        
        _screenFrame = [UIScreen mainScreen].bounds;
        _width = _screenFrame.size.width;
        _height = _screenFrame.size.height;
        
        _deviceW = [UIScreen mainScreen].currentMode.size.width / [UIScreen mainScreen].scale;
        _deviceH = [UIScreen mainScreen].currentMode.size.height / [UIScreen mainScreen].scale;
        
        _isPhone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
        _isPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
        
        _systemVersion = [UIDevice currentDevice].systemVersion.doubleValue;
        
        _isIphoneX = [self checkIsIphoneX];
        
        [self orientationDidChange:YES];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithPortraitPhoneSize:PRLayouterDesignedSizeForPhonePortrait portraitPadSize:PRLayouterDesignedSizeForPadPortrait];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orientationDidChange
{
    [self orientationDidChange:NO];
}

- (void)orientationDidChange:(BOOL)initialized
{
    _screenFrame = [UIScreen mainScreen].bounds;
    _width = _screenFrame.size.width;
    _height = _screenFrame.size.height;
    if (initialized) {
        _isPortrait = YES;
    } else {
        _isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    }
    
    [self updateLayouterSize];
    [self updateDeviceSafeInsets];
}

- (void)adjustFullView:(UIView *)view
{
    [self adjustFullViewForManualLayoutSubviews:view layoutSubviewsBlock:nil];
}

- (void)adjustFullViewForManualLayoutSubviews:(UIView *)view layoutSubviewsBlock:(void (^)(CGRect))block
{
    view.transform = CGAffineTransformIdentity;
    
    view.layer.anchorPoint = CGPointZero;
    view.frame = self.realSize;
    
    if (block) {
        block(view.frame);
    }
    
    view.transform = CGAffineTransformMakeScale(self.scale, self.scale);
}

- (void)adjustView:(UIView *)view withDesignedSize:(CGSize)designedSize presentedSize:(CGRect)presentedSize
{
    [self adjustViewForManualLayoutSubviews:view withDesignedSize:designedSize presentedSize:presentedSize layoutSubviewsBlock:nil];
}

- (void)adjustViewForAutoresizing:(UIView *)view withPresentedSize:(CGRect)presentedSize
{
    // 需要view在初始化阶段将frame初始化为designedSize
    [self adjustViewForManualLayoutSubviews:view withDesignedSize:view.frame.size presentedSize:presentedSize setDesignedSize:NO layoutSubviewsBlock:nil];
}

- (void)adjustViewForManualLayoutSubviews:(UIView *)view withDesignedSize:(CGSize)designedSize presentedSize:(CGRect)presentedSize layoutSubviewsBlock:(void (^)(CGRect))block
{
    [self adjustViewForManualLayoutSubviews:view withDesignedSize:designedSize presentedSize:presentedSize setDesignedSize:YES layoutSubviewsBlock:block];
}

- (void)adjustViewForManualLayoutSubviews:(UIView *)view withDesignedSize:(CGSize)designedSize presentedSize:(CGRect)presentedSize setDesignedSize:(BOOL)setDesignedSize layoutSubviewsBlock:(void (^)(CGRect))block
{
    if (CGSizeEqualToSize(designedSize, CGSizeZero)) {
        return;
    }
    
    if (CGSizeEqualToSize(presentedSize.size, CGSizeZero)) {
        return;
    }
    
    view.transform = CGAffineTransformIdentity;
    view.layer.anchorPoint = CGPointZero;
    
    if (setDesignedSize) {
        view.frame = CGRectMake(presentedSize.origin.x, presentedSize.origin.y, designedSize.width, designedSize.height);
    }
    
    CGFloat scale = 0;
    
    if (presentedSize.size.width == 0) {
        scale = presentedSize.size.height / designedSize.height;
    } else if (presentedSize.size.height == 0) {
        scale = presentedSize.size.width / designedSize.width;
    } else {
        // 过渡到实际尺寸，并且算好scale
        CGFloat xScale = presentedSize.size.width / designedSize.width;
        CGFloat yScale = presentedSize.size.height / designedSize.height;
        
        if (ABS(1 - xScale) > ABS(1 - yScale)) {
            view.frame = CGRectMake(presentedSize.origin.x, presentedSize.origin.y, designedSize.height * (presentedSize.size.width / presentedSize.size.height), designedSize.height);
            scale = yScale;
        } else {
            view.frame = CGRectMake(presentedSize.origin.x, presentedSize.origin.y, designedSize.width, designedSize.width * (presentedSize.size.height / presentedSize.size.width));
            scale = xScale;
        }
    }
    
    if (block) {
        block(view.frame);
    }
    
    view.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)clearAllAdjustForView:(UIView *)view
{
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    view.transform = CGAffineTransformIdentity;
}

#pragma mark - interface
+ (BOOL)isPhone
{
    return _instance.isPhone;
}

+ (BOOL)isPad
{
    return _instance.isPad;
}

+ (BOOL)isPortrait
{
    return _instance.isPortrait;
}

+ (CGFloat)systemVersion
{
    return _instance.systemVersion;
}

+ (CGRect)screenFrame
{
    return _instance.screenFrame;
}

+ (CGFloat)width
{
    return _instance.width;
}

+ (CGFloat)height
{
    return _instance.height;
}

+ (CGFloat)deviceWidth
{
    return _instance.deviceW;
}

+ (CGFloat)deviceHeight
{
    return _instance.deviceH;
}

+(CGFloat)statusBarHeight
{
    return _instance.statusBarHeight;
}

+ (CGFloat)scale
{
    return _instance.scale;
}

+ (CGRect)designSize
{
    return _instance.designSize;
}

+ (CGFloat)designWidth
{
    return _instance.designSize.size.width;
}

+ (CGFloat)designHeight
{
    return _instance.designSize.size.height;
}

+ (CGFloat)designWidthPortrait
{
    return _instance.designWidthPortrait;
}

+ (CGRect)realSize
{
    return _instance.realSize;
}

+ (void)adjustFullView:(UIView *)view
{
    [_instance adjustFullView:view];
}

+ (void)adjustFullViewForManualLayoutSubviews:(UIView *)view layoutSubviewsBlock:(void (^)(CGRect))block
{
    [_instance adjustFullViewForManualLayoutSubviews:view layoutSubviewsBlock:block];
}

+ (void)adjustView:(UIView *)view withDesignedSize:(CGSize)designedSize presentedSize:(CGRect)presentedSize
{
    [_instance adjustView:view withDesignedSize:designedSize presentedSize:presentedSize];
}

+ (void)adjustViewForAutoresizing:(UIView *)view withPresentedSize:(CGRect)presentedSize
{
    [_instance adjustViewForAutoresizing:view withPresentedSize:presentedSize];
}

+ (void)adjustViewForManualLayoutSubviews:(UIView *)view withDesignedSize:(CGSize)designedSize presentedSize:(CGRect)presentedSize layoutSubviewsBlock:(void (^)(CGRect))block
{
    [_instance adjustViewForManualLayoutSubviews:view withDesignedSize:designedSize presentedSize:presentedSize layoutSubviewsBlock:block];
}

+ (void)clearAllAdjustForView:(UIView *)view
{
    [_instance clearAllAdjustForView:view];
}

#pragma mark About: Device Safe Area Insets In Initialized Step
+ (BOOL)is_iPhoneX
{
    return _instance.isIphoneX;
}

+ (CGFloat)navigation_Bar_Height
{
    return _instance.pandaReaderNavigationHeight;
}

+ (CGFloat)navigation_Bar_ContainStatusBar_Height
{
    return _instance.pandaReaderNavigationHeightContainsStatusBar;
}

+ (CGFloat)navigation_Bar_Gap_X
{
    return _instance.pandaReaderNavigationGapX;
}

+ (CGFloat)navigation_Bar_Gap_2X
{
    return _instance.pandaReaderNavigationGap2X;
}

+ (CGFloat)navigation_Bar_Height_Portrait
{
    return _instance.pandaReaderNavigationHeightForcePortrait;
}

+ (CGFloat)navigation_Bar_ContainStatusBar_Height_Portrait
{
    return _instance.pandaReaderNavigationHeightContainsStatusBarForcePortrait;
}

+ (CGFloat)navigation_Bar_Gap_X_Portrait
{
    return _instance.pandaReaderNavigationGapXForcePortrait;
}

+ (CGFloat)navigation_Bar_Gap_2X_Portrait
{
    return _instance.pandaReaderNavigationGap2XForcePortrait;
}

+ (CGFloat)tabbar_Height
{
    return _instance.pandaReaderTabBarHeight;
}

+ (CGFloat)tabbar_Gap_2X
{
    return _instance.screenSafeInsetsBottom;
}

+ (CGFloat)tabbar_Gap_X
{
    return _instance.screenBottomGap;
}

+ (CGFloat)bottom_Height_X
{
    return _instance.pandaReaderBottomBarHeight;
}

+ (CGFloat)left_Gap_X
{
    return _instance.screenSafeInsetsLeft;
}

+ (CGFloat)right_Gap_X
{
    return _instance.screenSafeInsetsRight;
}



#pragma mark - private method
- (void)updateLayouterSize
{
    if (self.isPortrait) { // 竖屏
        
        if (self.isPad) { // iPad
            _designSize = (CGRect){CGPointZero, self.portraitPadSize};
        } else {
            _designSize = (CGRect){CGPointZero, self.portraitPhoneSize};
        }
        
        _designWidthPortrait = _designSize.size.width;
        _realSize = CGRectMake(0, 0, _designSize.size.width, _designSize.size.width * (self.height / self.width));
        
    } else { // 横屏
        
        if (self.isPad) { // iPad
            _designSize = (CGRect){CGPointZero, CGSizeMake(self.portraitPadSize.height, self.portraitPadSize.width)};
        } else {
            _designSize = (CGRect){CGPointZero, CGSizeMake(self.portraitPhoneSize.height, self.portraitPhoneSize.width)};
        }
        _realSize = CGRectMake(0, 0, _designSize.size.height * (self.width / self.height), _designSize.size.height);
    }
    
    _scale = _width / _realSize.size.width;
}

- (void)updateDeviceSafeInsets
{
    if ([self isIphoneX]) {
        if (self.isPortrait) { // 竖屏
            _screenSafeInsetsTop = 44;
            _screenSafeInsetsBottom = 34;
            _screenSafeInsetsLeft = 0;
            _screenSafeInsetsRight = 0;
            
            _pandaReaderNavigationHeight = 68;
            _pandaReaderNavigationHeightContainsStatusBar = 88;
            _pandaReaderNavigationGap2X = 44 - 20;
        } else { // 横屏
            _screenSafeInsetsTop = 0;
            _screenSafeInsetsBottom = 21;
            _screenSafeInsetsLeft = 44;
            _screenSafeInsetsRight = 44;
            
            _pandaReaderNavigationHeight = 44;
            _pandaReaderNavigationHeightContainsStatusBar = 64;
            _pandaReaderNavigationGap2X = 0;
        }
        
        _pandaReaderNavigationHeightForcePortrait = 44;
        _pandaReaderNavigationHeightContainsStatusBarForcePortrait = 88;
        _pandaReaderNavigationGap2XForcePortrait = 44 - 20;
        _screenBottomGap = 21;
        _statusBarHeight = 44.f;
        
    } else {
        _screenSafeInsetsTop = 0;
        _screenSafeInsetsBottom = 0;
        _screenSafeInsetsLeft = 0;
        _screenSafeInsetsRight = 0;
        
        _pandaReaderNavigationHeight = 44;
        _pandaReaderNavigationHeightContainsStatusBar = 64;
        _pandaReaderNavigationGap2X = 0;
        
        
        _pandaReaderNavigationHeightForcePortrait = 44;
        _pandaReaderNavigationHeightContainsStatusBarForcePortrait = 64;
        _pandaReaderNavigationGap2XForcePortrait = 0;
        _screenBottomGap = 0;
        _statusBarHeight = 20.f;
    }
    
    _pandaReaderNavigationGapX = _pandaReaderNavigationGap2X * 0.5;
    _pandaReaderNavigationGapXForcePortrait = _pandaReaderNavigationGap2XForcePortrait * 0.5;
    _pandaReaderTabBarHeight = 49 + _screenSafeInsetsBottom;
    _pandaReaderBottomBarHeight = 49 + _screenBottomGap;
}

- (BOOL)checkIsIphoneX
{
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}

@end

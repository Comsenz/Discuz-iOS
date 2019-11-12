//
//  UIView+PRLayouter.m
//  PandaReader
//
//  Created by changle on 2017/11/9.
//

#import "UIView+PRLayouter.h"
#import <objc/runtime.h>
#import "PRLayouter.h"

UIEdgeInsets func_safeAreaInsets(UIView *view, UIView *ancestorView, UIEdgeInsets insets, UIEdgeInsets ancestorInsets)
{
    // 计算
    if (view.superview == nil) { // 既不是根控制器，又没有superview
        return insets;
    }
    CGRect frame = [view.superview convertRect:view.frame toView:ancestorView];
    CGRect bounds = ancestorView.bounds;
    CGFloat left = ancestorInsets.left - frame.origin.x;
    if (left < 0) {
        left = 0;
    }
    if (left > ancestorInsets.left) {
        left = ancestorInsets.left;
    }
    
    CGFloat right = CGRectGetMaxX(frame) - (bounds.size.width - ancestorInsets.right);
    if (right < 0) {
        right = 0;
    }
    if (right > ancestorInsets.right) {
        right = ancestorInsets.right;
    }
    
    CGFloat top = ancestorInsets.top - frame.origin.y;
    if (top < 0) {
        top = 0;
    }
    if (top > ancestorInsets.top) {
        top = ancestorInsets.top;
    }
    
    CGFloat bottom = CGRectGetMaxY(frame) - (bounds.size.height - ancestorInsets.bottom);
    if (bottom < 0) {
        bottom = 0;
    }
    if (bottom > ancestorInsets.bottom) {
        bottom = ancestorInsets.bottom;
    }
    
    
    return UIEdgeInsetsMake(top + insets.top, left + insets.left, bottom + insets.bottom, right + insets.right);
}

CGRect func_safeArea(UIView *view, UIEdgeInsets insets)
{
    CGRect bounds = view.bounds;
    
    if (insets.left < 0) {
        insets.left = 0;
    }
    if (insets.left > bounds.size.width) {
        insets.left = bounds.size.width;
    }
    
    if (insets.top < 0) {
        insets.top = 0;
    }
    if (insets.top > bounds.size.height) {
        insets.top = bounds.size.height;
    }
    
    if (insets.right < 0) {
        insets.right = 0;
    }
    if (bounds.size.width - insets.right < insets.left) {
        insets.right = bounds.size.width - insets.left;
    }
    
    if (insets.bottom < 0) {
        insets.bottom = 0;
    }
    if (bounds.size.height - insets.bottom < insets.top) {
        insets.bottom = bounds.size.height - insets.top;
    }
    
    return CGRectMake(insets.left, insets.top, ABS(bounds.size.width - insets.left - insets.right), ABS(bounds.size.height - insets.top - insets.bottom));
}

@interface UIViewController ()

@property (nonatomic, assign, readonly) UIEdgeInsets pr_safeAreaInsets;

@end



@implementation UIView (PRLayouter)

- (UIEdgeInsets)pr_safeAreaInsets
{
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    } else {
        UIViewController *vc = self.pr_parentViewController;
        if (!vc) {
            return UIEdgeInsetsZero;
        }
        
        // 用同样的方式，计算self与vc.view的相交insets
        return func_safeAreaInsets(self, vc.view, UIEdgeInsetsZero, vc.pr_safeAreaInsets);
    }
}

- (CGRect)pr_safeArea
{
    CGRect safeArea = self.bounds;
    if (@available(iOS 11.0, *)) {
        safeArea = self.safeAreaLayoutGuide.layoutFrame;
    } else {
        UIEdgeInsets safeAreaInsets = self.pr_safeAreaInsets;
        if (UIEdgeInsetsEqualToEdgeInsets(safeAreaInsets, UIEdgeInsetsZero)) {
            return safeArea;
        }
        safeArea = func_safeArea(self, safeAreaInsets);
    }
    
    
    return safeArea;
}

- (BOOL)pr_isFullScreen
{
    if (CGRectEqualToRect(self.frame, [UIScreen mainScreen].bounds)) {
        return YES;
    }
    
    if (self.pr_allScale == [PRLayouter scale] && CGRectEqualToRect(self.bounds, [PRLayouter realSize])) {
        return YES;
    }
    
    return NO;
}

- (CGFloat)pr_allScale
{
    CGFloat allScale = 1;
    UIView *superview = self;
    while (superview) {
        if (superview.transform.a != superview.transform.d) {
            return 1;
        }
        allScale *= superview.transform.a;
        superview = superview.superview;
    }
    
    return allScale;
}

- (CGRect)pr_scaledSafeArea
{
    CGRect safeArea = self.pr_safeArea;
    
    //    CGFloat scale = 0;
    //    if (self.pr_isFullScreen) {
    //        scale = [UIScreen mainScreen].bounds.size.width / self.bounds.size.width;
    //    } else {
    //        scale = 1; // 局部视图的scale，必须要知道局部视图的设计尺寸
    //    }
    
    CGFloat scale = self.pr_allScale;
    if (ABS(scale - 1.0) < 1e-4) {
        return safeArea;
    }
    
    CGFloat topH = safeArea.origin.y;
    CGFloat bottomH = self.bounds.size.height - safeArea.size.height - safeArea.origin.y;
    CGFloat leftW = safeArea.origin.x;
    CGFloat rightW = self.bounds.size.width - safeArea.size.width - safeArea.origin.x;
    
    
    CGFloat topOffset = topH - (topH / scale);
    safeArea.origin.y -= topOffset;
    safeArea.size.height += topOffset;
    
    CGFloat bottomOffset = bottomH - (bottomH / scale);
    safeArea.size.height += bottomOffset;
    
    CGFloat leftOffset = leftW - (leftW / scale);
    safeArea.origin.x -= leftOffset;
    safeArea.size.width += leftOffset;
    
    CGFloat rightOffset = rightW - (rightW / scale);
    safeArea.size.width += rightOffset;
    return safeArea;
}

- (UIEdgeInsets)pr_scaleInsets:(UIEdgeInsets)safeAreaInsets
{
    CGFloat scale = self.pr_allScale;
    if (ABS(scale - 1.0) < 1e-4) {
        return safeAreaInsets;
    }
    
    return UIEdgeInsetsMake(safeAreaInsets.top / scale, safeAreaInsets.left / scale, safeAreaInsets.bottom / scale, safeAreaInsets.right / scale);
}

- (UIEdgeInsets)pr_scaledSafeAreaInsets
{
    return [self pr_scaleInsets:self.pr_safeAreaInsets];
}


- (UIViewController *)pr_parentViewController
{
    UIResponder *nextResponder = self.nextResponder;
    while (nextResponder && ![nextResponder isKindOfClass:[UIViewController class]]) {
        nextResponder = nextResponder.nextResponder;
    }
    
    return (UIViewController *)nextResponder;
}

@end


static const char kPRAdditionalSafeAreaInsetsProperty;
@implementation UIViewController (PRLayouter)

- (void)setPr_additionalSafeAreaInsets:(UIEdgeInsets)pr_additionalSafeAreaInsets
{
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = pr_additionalSafeAreaInsets;
    } else {
        objc_setAssociatedObject(self, &kPRAdditionalSafeAreaInsetsProperty, [NSValue valueWithUIEdgeInsets:pr_additionalSafeAreaInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIEdgeInsets)pr_additionalSafeAreaInsets
{
    if (@available(iOS 11.0, *)) {
        return self.additionalSafeAreaInsets;
    } else {
        return [objc_getAssociatedObject(self, &kPRAdditionalSafeAreaInsetsProperty) UIEdgeInsetsValue];
    }
}

- (UIEdgeInsets)pr_safeAreaInsets
{
    UIEdgeInsets insets = self.pr_additionalSafeAreaInsets;
    
    if (self.parentViewController == nil) {
        return UIEdgeInsetsMake(insets.top + self.topLayoutGuide.length, 0, insets.bottom + self.bottomLayoutGuide.length, 0);
    }
    
    // +
    
    // self.view.frame与parentVc.view.bounds以及parentVc.pr_safeAreaInsets相交的insets
    UIViewController *parentVc = self.parentViewController;
    UIEdgeInsets parentInsets = parentVc.pr_safeAreaInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(parentInsets, UIEdgeInsetsZero)) {
        return insets;
    }
    
    return func_safeAreaInsets(self.view, parentVc.view, insets, parentInsets);
    
}

- (UIEdgeInsets)pr_scaledAdditionalSafeAreaInsets
{
    return [self.view pr_scaleInsets:self.pr_additionalSafeAreaInsets];
}

@end

@implementation UIScrollView (PRLayouter)

- (void)pr_autoAdjustContentInsetsScrollsToTop:(BOOL)scrollsToTop
{
    if (@available(iOS 11.0, *)) {
        
    } else {
        UIEdgeInsets safeAreaInset = self.pr_safeAreaInsets;
        self.contentInset = safeAreaInset;
        self.scrollIndicatorInsets = safeAreaInset;
        if (scrollsToTop) {
            self.contentOffset = CGPointMake(-self.contentInset.left, -self.contentInset.top);
        }
    }
}

@end


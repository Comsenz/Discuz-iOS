//
//  DZRootTabBar.m
//  PandaReader
//
//  Created by WebersonGao on 2019/3/7.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "DZRootTabBar.h"


#define TabbarItemNums  3.0    //tabbar的数量

@interface DZRootTabBar ()
{
    CGFloat badgeDotWH;
}

@end

@implementation DZRootTabBar

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configRootTabBarSubView];
}

-(void)configRootTabBarSubView{
    self.translucent = NO;
    badgeDotWH = KWidthScale(6.f);
    self.tintColor = KColor(KFFCE2E_Color, 1.0);
    self.barTintColor = KColor(K2A2C2F_Color, 1.0);
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha= (hidden ? 0 : 1);
        } completion:^(BOOL finished) {
            [self setHidden:hidden];
        }];
    } else {
        [self setHidden:hidden];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}


// WBS 显示小红点
- (void)showBadgeOnItemIndex:(TabItemIndex)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    CGRect tabFrame = self.frame;
    UIImageView *badgeDotView = [[UIImageView alloc] initWithImage:KImageNamed(@"me_tab_redDot")];
    badgeDotView.tag = 888 + index;
    
    //确定位置
    CGFloat percentX = (index + 0.55) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.16 * (tabFrame.size.height - KTabbar_Gap));
    badgeDotView.frame = CGRectMake(x, y, badgeDotWH, badgeDotWH);
    [self addSubview:badgeDotView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(TabItemIndex)index{
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(TabItemIndex)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            CGRect frame = subview.frame;
            frame.size.height = (KTabbar_Height - KTabbar_Gap) - 1;
            subview.frame = frame;
        }
    }
}


@end

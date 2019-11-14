//
//  UIBarButtonItem+TPBarButtonItem.m
//  PandaReader
//
//  Created by WebersonGao on 2019/4/4.
//  Copyright © 2019 ZHWenXue. All rights reserved.
//

#import "UIBarButtonItem+TPBarButtonItem.h"
#import "TPNavItemButton.h"

@implementation UIBarButtonItem (TPBarButtonItem)


- (UIBarButtonItem *)initWithItemImageName:(NSString *)itemImageName target:(id)target action:(SEL)action {
    
    return [self initWithItemImageName:itemImageName HighImageName:nil ItemTitle:nil TitleColor:nil HighTitleColor:nil TitleFont:0 Bold:NO Layout:YES target:target action:action];
}

- (UIBarButtonItem *)initWithItemImageName:(NSString *)itemImageName Layout:(BOOL)isLeft target:(id)target action:(SEL)action {
    
    return [self initWithItemImageName:itemImageName HighImageName:nil ItemTitle:nil TitleColor:nil HighTitleColor:nil TitleFont:0 Bold:NO Layout:isLeft target:target action:action];
    
}

- (UIBarButtonItem *)initWithItemTitle:(NSString *)itemTitle Layout:(BOOL)isLeft target:(id)target action:(SEL)action {
    
    return [self initWithItemImageName:nil HighImageName:nil ItemTitle:itemTitle TitleColor:[UIColor blackColor] HighTitleColor:[UIColor blackColor] TitleFont:16 Bold:NO Layout:isLeft target:target action:action];
}

- (UIBarButtonItem *)initWithItemImageName:(NSString *)itemImageName HighImageName:(NSString *)highImageName ItemTitle:(NSString *)itemTitle TitleColor:(UIColor *)titleColor HighTitleColor:(UIColor *)highTitleColor TitleFont:(CGFloat)titleFont Bold:(BOOL)isBold Layout:(BOOL)isLeft target:(id)target action:(SEL)action {
    
    self = [self init];
    if (self) {
        //创建btn
        TPNavItemButton *btn = [[TPNavItemButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        [btn setTitle:itemTitle forState:UIControlStateNormal];
        [btn.titleLabel setFont:isBold ? [UIFont boldSystemFontOfSize:titleFont] : [UIFont systemFontOfSize:titleFont]];
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitleColor:highTitleColor ? highTitleColor : titleColor forState:UIControlStateHighlighted];
        [btn.titleLabel setTextAlignment:isLeft ? NSTextAlignmentLeft : NSTextAlignmentRight];
        [btn setImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:highImageName.length ? highImageName : itemImageName] forState:UIControlStateHighlighted];
        if (itemTitle.length) {
            [btn sizeToFit];
        }else {
            btn.isLeft = isLeft;
        }
        if ([itemImageName isEqualToString:@"reader_naviBack"]) {
            //返回按钮里面的x坐标间距需要调整
            btn.isBack = YES;
        }
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = btn;
    }
    return self;
    
}


@end

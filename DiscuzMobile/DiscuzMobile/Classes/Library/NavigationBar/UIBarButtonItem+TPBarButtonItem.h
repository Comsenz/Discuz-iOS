//
//  UIBarButtonItem+TPBarButtonItem.h
//  PandaReader
//
//  Created by WebersonGao on 2019/4/4.
//  Copyright © 2019 ZHWenXue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TPBarButtonItem)

/**
 创建自定义的UIBarButtonItem
 
 @param itemImageName 图片名
 @param highImageName 高亮图片名
 @param itemTitle 文本
 @param titleColor 文本颜色
 @param highTitleColor 高亮文本颜色
 @param titleFont 文本大小
 @param isBold 是否加粗
 @param isLeft 左边/右边 item
 @param target 点击代理
 @param action 点击事件
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)initWithItemImageName:(NSString *)itemImageName HighImageName:(NSString *)highImageName ItemTitle:(NSString *)itemTitle TitleColor:(UIColor *)titleColor HighTitleColor:(UIColor *)highTitleColor TitleFont:(CGFloat)titleFont Bold:(BOOL)isBold Layout:(BOOL)isLeft target:(id)target action:(SEL)action;

/**
 返回单图 左边 的 UIBarButtonItem
 
 @param itemImageName 图片名
 @param target 点击代理
 @param action 点击事件
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)initWithItemImageName:(NSString *)itemImageName target:(id)target action:(SEL)action;

/**
 返回单图的 UIBarButtonItem
 
 @param itemImageName 图片名
 @param isLeft 左右 item
 @param target 点击代理
 @param action 点击事件
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)initWithItemImageName:(NSString *)itemImageName Layout:(BOOL)isLeft target:(id)target action:(SEL)action;

/**
 返回文本按钮 UIBarButtonItem
 
 @param itemTitle 文本内容
 @param isLeft 左右item
 @param target 点击代理
 @param action 点击事件
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)initWithItemTitle:(NSString *)itemTitle Layout:(BOOL)isLeft target:(id)target action:(SEL)action;

@end

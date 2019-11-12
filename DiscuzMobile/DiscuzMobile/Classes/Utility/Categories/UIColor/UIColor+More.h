//
//  UIColor+More.h
//  PandaReader
//
//  Created by WebersonGao on 2019/3/1.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (More)

+ (UIColor *)color16WithHexString:(NSString *)color alpha:(float)ap;
+ (UIColor *)colorWithString:(NSString *)colorstr;
+ (UIColor *)color16WithHexString:(NSString *)color;
+(UIColor*)mainColor:(UIImage*)image;
+(UIColor *)imagePaletteColorString:(NSDictionary *)allModeColorDic;
@end

NS_ASSUME_NONNULL_END

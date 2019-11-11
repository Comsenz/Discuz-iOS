//
//  Color.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/1.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

// 颜色文件
#ifndef Color_h
#define Color_h

#define mRGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RANDOM_COLOR  mRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

//#define MAINCOLOR mRGBColor(220, 130, 0)

#define BTN_USE_COLOR [UIColor whiteColor]
#define NAVI_BUTTON_COLLOR MAINCOLOR
#define MAIN_COLLOR MAINCOLOR
#define NAVI_BAR_COLOR [UIColor whiteColor]
#define NAVI_TITLE_COLOR  MAINCOLOR
#define MAIN_TITLE_COLOR  mRGBColor(51, 51, 51)
#define LIGHT_TEXT_COLOR  mRGBColor(153, 153, 153)
#define MAIN_GRAY_COLOR mRGBColor(238, 238, 238)
#define LINE_COLOR mRGBColor(238, 238, 238)
#define NAV_SEP_COLOR mRGBColor(190, 190, 190)
#define MESSAGE_COLOR mRGBColor(102,102,102)
#define DARK_TEXT_COLOR mRGBColor(83,83,83)
#define FORUM_GRAY_COLOR mRGBColor(239, 240, 241)

#define TOOL_BACK_COLOR mRGBColor(209, 213, 218)
#define TOOLBAR_BACK_COLOR mRGBColor(236, 236, 236)
#define DISABLED_COLOR mRGBColor(190, 190, 190)


#endif /* Color_h */

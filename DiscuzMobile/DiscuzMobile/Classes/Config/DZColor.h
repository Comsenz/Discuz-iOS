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

#define mRGBColor(r, g, b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define KRandom_Color        mRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

#define K_Color_btn_user       [UIColor whiteColor]
#define K_Color_NaviButton  DZ_MAINCOLOR
#define K_Color_Theme         DZ_MAINCOLOR
#define K_Color_NaviBar      [UIColor whiteColor]
#define K_Color_NaviTitle    DZ_MAINCOLOR
#define K_Color_MainTitle    mRGBColor(51, 51, 51)
#define K_Color_LightText    mRGBColor(153, 153, 153)
#define K_Color_MainGray     mRGBColor(238, 238, 238)
#define K_Color_Line          mRGBColor(238, 238, 238)
#define K_Color_NaviBack       mRGBColor(190, 190, 190)
#define K_Color_Message       mRGBColor(102,102,102)
#define K_Color_DarkText     mRGBColor(83,83,83)
#define K_Color_ForumGray    mRGBColor(239, 240, 241)

#define K_Color_ToolBack     mRGBColor(209, 213, 218)
#define K_Color_ToolBar  mRGBColor(236, 236, 236)
#define K_Color_Disabled      mRGBColor(190, 190, 190)


#endif /* Color_h */

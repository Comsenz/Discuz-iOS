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

#define mRGBColor(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define KRandom_Color        mRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))
#define KColor(colorName,alphaValue)  [UIColor color16WithHexString:colorName alpha:alphaValue]

#define K_Color_btn_user     [UIColor whiteColor]
#define K_Color_NaviButton   DZ_MAINCOLOR
#define K_Color_Theme        DZ_MAINCOLOR
#define K_Color_NaviBar      [UIColor whiteColor]
#define K_Color_NaviTitle    DZ_MAINCOLOR
#define K_Color_MainTitle    mRGBColor(51, 51, 51)
#define K_Color_LightText    mRGBColor(153, 153, 153)
#define K_Color_MainGray     mRGBColor(238, 238, 238)
#define K_Color_Line         mRGBColor(238, 238, 238)
#define K_Color_NaviBack     mRGBColor(190, 190, 190)
#define K_Color_Message      mRGBColor(102,102,102)
#define K_Color_DarkText     mRGBColor(83,83,83)
#define K_Color_ForumGray    mRGBColor(239, 240, 241)

#define K_Color_ToolBack     mRGBColor(209, 213, 218)
#define K_Color_ToolBar      mRGBColor(236, 236, 236)
#define K_Color_Disabled     mRGBColor(190, 190, 190)


#define KFFCE2E_Color  @"#FFCE2E" //黄色
#define KFD8D2F_Color  @"#FD8D2F"
#define K2D3035_Color  @"#2D3035"
#define K8D8E91_Color  @"#8D8E91"
#define KFFFFFF_Color  @"#FFFFFF" // 白
#define KFF6565_Color  @"#FF6565"
#define KF0F0F0_Color  @"#F0F0F0"
#define K000000_Color  @"#000000" //黑
#define KBDC0C6_Color  @"#BDC0C6" // 按钮禁用
#define KECECEC_Color  @"#ECECEC" // 分割线
#define KF7F7F8_Color  @"#F7F7F8" // 点击高亮色
#define KCDCDCD_Color  @"#CDCDCD"
#define KFCA43B_Color  @"#FCA43B"
#define K2A2C2F_Color  @"#2A2C2F" //tabbar 黑色

#define K241217_Color  @"#241217"




#define KFont(fontSize)             [UIFont systemFontOfSize:fontSize]
#define KBoldFont(fontSize)         [UIFont systemFontOfSize:fontSize]
#define KExtraBoldFont(fontSize)    [UIFont systemFontOfSize:fontSize]

#endif /* Color_h */

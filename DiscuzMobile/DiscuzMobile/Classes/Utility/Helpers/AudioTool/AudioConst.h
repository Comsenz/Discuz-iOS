//
//  AudioConst.h
//  audio
//
//  Created by ZhangJitao on 2018/8/6.
//  Copyright © 2018年 Piter Zhang. All rights reserved.
//

#ifndef AudioConst_h
#define AudioConst_h

typedef NS_ENUM(NSUInteger, RecordStatus) {
    r_init,
    r_recording,
    r_stop,
    r_pause,
    r_play,
};
#define A_WIDTH [UIScreen mainScreen].bounds.size.width
#define A_HEIGHT [UIScreen mainScreen].bounds.size.height

#define A_RGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define A_TEXT_COLOR  A_RGBColor(153, 153, 153)

#endif /* AudioConst_h */

//
//  AudioTool.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/16.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioTool : NSObject

@property (nonatomic, strong) NSString *recordPath;
@property (nonatomic, strong) NSURL *mp3Url;
@property (nonatomic, assign) NSInteger recordTime;

@property (nonatomic, strong) NSMutableArray *audioArray;

+ (instancetype)shareInstance;


/**
 开始录音
 
 @return 录音路径
 */
- (NSString *)startRecord;


/**
 停止录音
 */
- (void)stopRecord;


/**
 转换为mp3
 
 @param recordPath 录音的路径
 */
- (void)transformMp3:(NSString *)recordPath;


/**
 播放列表mp3
 
 @param url mp3url
 */
- (void)playlistAudio:(NSURL *)url;


/**
 播放
 */
- (void)playRecord;


/**
 停止播放
 */
- (void)pausePlayRecord;

/**
 停止播放
 */
- (void)stopPlayRecord;

- (void)sliderToPlay:(float)progress;



/**
 重录
 */
- (void)resetRecord;

- (void)initAudio;


/**
 清空录音
 */
- (void)clearAudio;

@end

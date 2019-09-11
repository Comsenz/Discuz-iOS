//
//  AudioManager.h
//  audio
//
//  Created by ZhangJitao on 2018/8/6.
//  Copyright © 2018年 Piter Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AudioRecordView;

@interface AudioManager : NSObject

+ (void)setAudioTool:(AudioRecordView *)audioRecordView;

+ (NSMutableArray *)upLoadAudioArray;

+ (void)clearAudio;

+ (void)playWithUrl:(NSURL *)url;

+ (void)stopPlay;

@end

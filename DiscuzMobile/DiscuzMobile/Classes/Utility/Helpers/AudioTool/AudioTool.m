//
//  AudioTool.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/16.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "AudioModel.h"
#import "AudioConst.h"

@interface AudioTool()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
// 录音
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, assign) RecordStatus status;

@end

@implementation AudioTool

+ (instancetype)shareInstance {
    static AudioTool *adTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adTool = [[AudioTool alloc] init];
    });
    return adTool;
}


/**
 开始录音

 @return 录音路径
 */
- (NSString *)startRecord {
    
    self.recordTime = 0;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error create session:%@", [sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }
    
    self.session = session;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.recordPath = [path stringByAppendingString:[NSString stringWithFormat:@"/RRecord%ld.wav",self.audioArray.count]];
    //2.获取文件路径
   NSURL *recordFileUrl = [NSURL fileURLWithPath:self.recordPath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 11025],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
    } else {
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
    return self.recordPath;
}


/**
 停止录音
 */
- (void)stopRecord {
    NSLog(@"停止录音");
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    if (self.recordTime < 2) {
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.recordPath]) {
        
        [self transformMp3:self.recordPath];
        
    } else {
        
    }
}


/**
 转换为mp3

 @param recordPath 录音的路径
 */
- (void)transformMp3:(NSString *)recordPath {
    //如果要保存下来自己听，就将mp3保存到到Document中，如下代码，如果不的话，就保存到Temp文件中
    NSString *nowTime = [NSString stringWithFormat:@"luyin%ld",self.audioArray.count];
    NSString *fileName = [NSString stringWithFormat:@"/%@.mp3", nowTime];
    NSString *filePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:fileName];
    _mp3Url = [NSURL URLWithString:filePath];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([recordPath cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR);//删除头，否则在前一秒钟会有杂音
        FILE *mp3 = fopen([filePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        //这里要注意，lame的配置要跟AVAudioRecorder的配置一致，否则会造成转换不成功
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025);//采样率 11025.0
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功!!!");
        // 删除源文件
        [self removeFileWithPath:self.recordPath];
    }
}


/**
 播放列表mp3

 @param url mp3url
 */
- (void)playlistAudio:(NSURL *)url {
    [self.recorder stop];
    if ([self.player isPlaying]) {
        [self.player stop];
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    NSLog(@"%li",self.player.data.length/1024);
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}

/**
 播放
 */
- (void)playRecord {
    if (self.status == r_pause) {
        [self.player play];
    } else {
        [self playlistAudio:self.mp3Url];
    }
    self.status = r_play;
    
}


/**
 停止播放
 */
- (void)stopPlayRecord {
    NSLog(@"停止播放");
    self.status = r_stop;
    [self.player stop];
}

- (void)pausePlayRecord {
    NSLog(@"停止播放");
    self.status = r_pause;
    [self.player pause];
}

- (void)sliderToPlay:(float)progress {
    float playtime =  progress * self.recordTime;
    [self.player pause];
//    [self.player playAtTime:playtime];
    self.player.currentTime = playtime;
    [self.player play];
}


/**
 重录
 */
- (void)resetRecord {
    NSLog(@"重录");
    [self removeFileWithPath:self.recordPath];
    [self initAudio];
}

- (void)clearAudio {
    [self initAudio];
    for (AudioModel *audio in self.audioArray) {
        NSString *mp3Path = audio.mp3Url.absoluteString;
        [self removeFileWithPath:mp3Path];
    }
    if (self.audioArray.count > 0) {
        [self.audioArray removeAllObjects];
    }
}


- (void)initAudio {
    self.recordTime = 0;
    self.mp3Url = nil;
    self.recordPath = nil;
    self.status = r_init;
}

/**
 * 移除文件共有方法
 */
- (void)removeFileWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
}

- (NSMutableArray<AudioModel *> *)audioArray {
    if (!_audioArray) {
        _audioArray = [NSMutableArray array];
    }
    return _audioArray;
}

@end

//
//  LongPressRecord.m
//  testYUyin
//
//  Created by HB on 2017/5/11.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "AudioRecordView.h"
#import "AudioConst.h"

@interface AudioRecordView()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) RecordStatus recordStatus;
@property (nonatomic, assign) NSInteger recordTime; // 录音总时长
@property (nonatomic, assign) NSInteger playTime;   // 播放时的时间（播放到第几秒sha）

@end

@implementation AudioRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake((A_WIDTH - 100) / 2, 10, 100, 20)];
    self.timeLab.font = [UIFont systemFontOfSize:14];
    self.timeLab.textColor = A_TEXT_COLOR;
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.timeLab];
    
    self.longPressImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Recording"]];
    self.longPressImageV.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startRecord:)];
    longGes.minimumPressDuration = 0.5;
    [self.longPressImageV addGestureRecognizer:longGes];
    [self addSubview:self.longPressImageV];
    CGFloat width = 200;
    self.longPressImageV.frame = CGRectMake((A_WIDTH - width) / 2, 35, width, width / 2);
    
    
    self.playImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playRecord"]];
    self.playImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBtnAction:)];
    longGes.minimumPressDuration = 0.5;
    [self.playImageV addGestureRecognizer:tapGes];
    [self addSubview:self.playImageV];
    self.playImageV.frame = CGRectMake((A_WIDTH - width) / 2, 35, width, width / 2);
    self.playImageV.hidden = YES;
    
    CGFloat resWidth = 40;
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.resetBtn.frame = CGRectMake(width - resWidth, width / 2 - resWidth, resWidth, resWidth);
    [self.playImageV addSubview:self.resetBtn];
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.resetBtn.layer.borderWidth = 1;
    self.resetBtn.layer.cornerRadius = resWidth / 2;
    [self.resetBtn setTitle:@"重录" forState:(UIControlStateNormal)];
    self.resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.resetBtn setTintColor:[UIColor redColor]];
    [self.resetBtn addTarget:self action:@selector(resetAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.uploadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.uploadBtn.frame = CGRectMake(CGRectGetMaxX(self.playImageV.frame), CGRectGetMinY(self.playImageV.frame), resWidth, resWidth);
    [self addSubview:self.uploadBtn];
    self.uploadBtn.layer.masksToBounds = YES;
    self.uploadBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.uploadBtn.layer.borderWidth = 1;
    self.uploadBtn.layer.cornerRadius = resWidth / 2;
    [self.uploadBtn setTitle:@"上传" forState:(UIControlStateNormal)];
    self.uploadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.uploadBtn setTintColor:[UIColor redColor]];
    self.uploadBtn.hidden = YES;
    [self.uploadBtn addTarget:self action:@selector(uploadAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.tipLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.longPressImageV.frame) - 100, CGRectGetMaxY(self.longPressImageV.frame) + 20, 200, 15)];
    self.tipLab.font = [UIFont systemFontOfSize:14.0];
    self.tipLab.textAlignment = NSTextAlignmentCenter;
    self.tipLab.text = @"长按开始录音";
    [self addSubview:self.tipLab];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tipLab.frame) + 10, CGRectGetWidth(self.frame) - 30, 10)];
     [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.value = 0;
    self.slider.hidden = YES;
    [self addSubview:self.slider];
    
    self.recordStatus = r_init;
}

- (void)sliderValueChanged:(UISlider *)slider {
    NSLog(@"slider value%f",slider.value);
    self.playTime = (NSInteger)(self.recordTime  * (1 - slider.value));
    self.sliderBlock?self.sliderBlock(slider.value):nil;
    if (self.recordStatus == r_play) {
        [self playRecord];
    } else {
        [self pause];
    }
}


- (void)startRecord:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state ==  UIGestureRecognizerStateBegan) {
        NSLog(@"开始录音");
        self.recordTime = 0;
        if (self.startRecordBlock) {
            self.startRecordBlock();
        }
        self.tipLab.text = @"松开停止录音";
        self.recordStatus = r_recording;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordingAction:) userInfo:nil repeats:YES];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束录音");
        if (self.recordTimeBlock) {
            self.recordTimeBlock(self.recordTime);
        }
        [self stopRecord];
        self.slider.hidden = NO;
        
    }
    
}

// 录音进行时
- (void)recordingAction:(NSTimer *)timer {
    
    self.recordTime ++;
    self.timeLab.hidden = NO;
    self.timeLab.text = [NSString stringWithFormat:@"%ld秒",self.recordTime];
    if (self.recordTime >= 30) {
        [timer invalidate];
        if (self.recordTimeBlock) {
            self.recordTimeBlock(self.recordTime);
        }
        timer = nil;
        [self stopRecord];
    }
}

// 停止录音
- (void)stopRecord {
    self.tipLab.text = @"播放";
    self.tipLab.textColor = A_TEXT_COLOR;
    self.playImageV.hidden = NO;
    self.longPressImageV.hidden = YES;
    self.uploadBtn.hidden = NO;
    self.recordStatus = r_stop;
    [self.timer invalidate];
    if (self.stopRecordBlock) {
        self.stopRecordBlock();
    }
}

// 播放或者暂停
- (void)playBtnAction:(UITapGestureRecognizer *)gestureRecognizer {
    self.recordStatus = (self.recordStatus == r_play)?r_pause:r_play;
    if (self.recordStatus == r_play) {
        [self playRecord];
    } else {
        [self pause];
    }
    
}

// 播放
- (void)playRecord {
    NSLog(@"播放");
    if (self.playRecordBlock) {
        self.playRecordBlock();
    }
    [self removeTimer];
    
    if (self.playTime == 0) {
        self.playTime = self.recordTime;
    }
    self.timeLab.text = [NSString stringWithFormat:@"%ld秒",self.playTime];
    self.playImageV.image = [UIImage imageNamed:@"pause"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playingAction:) userInfo:nil repeats:YES];
}

// 播放进行时
- (void)playingAction:(NSTimer *)timer {
    self.recordStatus = r_play;
    self.playTime --;
    self.timeLab.hidden = NO;
    self.timeLab.text = [NSString stringWithFormat:@"%ld秒",self.playTime];
    NSInteger recTime = (self.recordTime - self.playTime);
    float changeValue = [[NSNumber numberWithInteger:recTime] floatValue] / self.recordTime;
    [self.slider setValue:changeValue animated:YES];
    if (self.playTime <= 0) {
        [self playCompleted];
        [timer invalidate];
        timer = nil;
    }

}

// 停止、暂停
- (void)pause {
    NSLog(@"暂停");
    self.recordStatus = r_pause;
    if (self.pausePlayBlock) {
        self.pausePlayBlock();
    }
    [self removeTimer];
    self.playImageV.image = [UIImage imageNamed:@"playRecord"];
    self.timeLab.hidden = NO;
    self.timeLab.text = [NSString stringWithFormat:@"%ld秒",self.playTime];
}

- (void)playCompleted {
    NSLog(@"停止了");
    if (self.stopPlayBlock) {
        self.stopPlayBlock();
    }
    [self removeTimer];
    self.recordStatus = r_stop;
    self.playImageV.image = [UIImage imageNamed:@"playRecord"];
    self.timeLab.hidden = NO;
    self.timeLab.text = [NSString stringWithFormat:@"%ld秒",self.recordTime];
    self.slider.value = 0;
}

// 重录
- (void)resetAction {
    [self initRecordView];
    if (self.resetRecordBlock) {
        self.resetRecordBlock();
    }
}

- (void)initRecordView {
    [self removeTimer];
    self.recordStatus = r_init;
    self.playImageV.hidden = YES;
    self.longPressImageV.hidden = NO;
    self.tipLab.text = @"长按开始录音";
    self.tipLab.textColor = A_TEXT_COLOR;
    self.timeLab.hidden = YES;
    self.uploadBtn.hidden = YES;
    self.slider.value = 0;
    self.slider.hidden = YES;
    if (self.stopPlayBlock) {
        self.stopPlayBlock();
    };
}

- (void)uploadAction {
    if (self.uploadBlock) {
        self.uploadBlock();
    }
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

//
//  AudioRecordView.h
//  testYUyin
//
//  Created by HB on 2017/5/11.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StartRecordBlock)(void);
typedef void(^StopRecordBlock)(void);
typedef void(^PlayRecordBlock)(void);
typedef void(^PausePlayBlock)(void);
typedef void(^StopPlayBlock)(void);
typedef void(^ResetRecordBlock)(void);
typedef void(^UploadBlock)(void);
typedef void(^RecordTimeBlock)(NSInteger time);
typedef void(^SliderBlock)(float progress);

@interface AudioRecordView : UIView

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *longPressImageV;
@property (nonatomic, strong) UIImageView *playImageV;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *uploadBtn;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, copy) StartRecordBlock startRecordBlock;
@property (nonatomic, copy) StopRecordBlock stopRecordBlock;
@property (nonatomic, copy) PlayRecordBlock playRecordBlock;
@property (nonatomic, copy) PausePlayBlock pausePlayBlock;
@property (nonatomic, copy) StopPlayBlock stopPlayBlock;
@property (nonatomic, copy) ResetRecordBlock resetRecordBlock;
@property (nonatomic, copy) SliderBlock sliderBlock;
@property (nonatomic, copy) UploadBlock uploadBlock;
@property (nonatomic, copy) RecordTimeBlock recordTimeBlock;

// 重录
- (void)resetAction;

@end

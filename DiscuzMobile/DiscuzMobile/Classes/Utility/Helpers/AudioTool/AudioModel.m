//
//  AudioModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "AudioModel.h"

@implementation AudioModel

- (instancetype)initAudioWithId:(NSString *)uploadId andMp3Url:(NSURL *)mp3Url {
    if (self = [super init]) {
        self.audioUploadId = uploadId;
        self.mp3Url = mp3Url;
    }
    return self;
}

+ (instancetype)audioWithId:(NSString *)uploadId andMp3Url:(NSURL *)mp3Url {
    AudioModel *model = [[AudioModel alloc] initAudioWithId:uploadId andMp3Url:mp3Url];
    return model;
}

@end

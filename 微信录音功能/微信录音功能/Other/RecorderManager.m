//
//  RecorderManager.m
//  微信录音功能
//
//  Created by 树清吴 on 2018/4/12.
//  Copyright © 2018年 BF. All rights reserved.
//

#import "RecorderManager.h"
#import <AVFoundation/AVFoundation.h>

@interface RecorderManager ()<AVAudioRecorderDelegate>

@property (nonatomic, assign) NSInteger audioName;

@property (nonatomic, strong) AVAudioRecorder *currentRecorder;

@property (nonatomic, strong) NSMutableDictionary *soundIDs;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RecorderManager

+ (instancetype)shared {
    static RecorderManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        
        instance.timer = [NSTimer timerWithTimeInterval:1 target:instance selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:instance.timer forMode:(NSRunLoopCommonModes)];
        instance.timer.fireDate = [NSDate distantFuture];
    });
    return instance;
}

- (void)record {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd.wav", self.audioName]];
    NSError *error;
    NSDictionary *setting = [NSDictionary dictionary];
    AVAudioRecorder *recoder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:audioPath] settings:setting error:&error];
    recoder.delegate = self;
    
    [recoder prepareToRecord];
    [recoder recordForDuration:60];
    
    self.audioName += 1;
    
    self.currentRecorder = recoder;
    
    recoder.meteringEnabled = YES;
    
    self.timer.fireDate = [NSDate date];
}

- (void)timerAction {
    [self.currentRecorder updateMeters];
    
    
    CGFloat result = pow(10, 0.05 * [self.currentRecorder averagePowerForChannel:0]);
    NSInteger level = 0;
    if (0 < result <= 0.027) {
        NSLog(@"%zd", 1);
        level = 1;
    } else if (0.027 < result <= 0.034) {
        NSLog(@"%zd", 2);
        level = 2;
    } else if (0.034 < result <= 0.041) {
        NSLog(@"%zd", 3);
        level = 3;
    } else if (0.041 < result <= 0.048) {
        NSLog(@"%zd", 4);
        level = 4;
    } else if (0.048 < result <= 0.055) {
        NSLog(@"%zd", 5);
        level = 5;
    } else if (0.055 < result) {
        NSLog(@"%zd", 6);
        level = 6;
    }
    
    if (self.recordingBlock) {
        self.recordingBlock(level);
    }
}

- (void)stop:(void (^)(NSTimeInterval, NSURL *))completion {
    NSTimeInterval time = self.currentRecorder.currentTime;
    [self.currentRecorder stop];
    self.timer.fireDate = [NSDate distantFuture];
    
    completion(time, self.currentRecorder.url);
}

- (void)playWithUrl:(NSURL *)url completionBlock:(void (^)())completion {
    SystemSoundID soundID;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);

    
    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        completion();
    });
    NSLog(@"%@", url.absoluteString);
    [self.soundIDs setObject:[NSNumber numberWithUnsignedInt:soundID] forKey: url.absoluteString];
}



- (void)pauseWithUrl:(NSURL *)url {
    AudioServicesDisposeSystemSoundID([[self.soundIDs objectForKey:url.absoluteString] unsignedIntValue]);
    [self.soundIDs removeObjectForKey:url.absoluteString];
}

// MARK: 代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"%zd", flag);
}


// MARK: 懒加载
- (NSMutableDictionary *)soundIDs {
    if (_soundIDs == nil) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}
@end

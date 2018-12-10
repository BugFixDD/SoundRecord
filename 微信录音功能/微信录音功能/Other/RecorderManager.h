//
//  RecorderManager.h
//  微信录音功能
//
//  Created by 树清吴 on 2018/4/12.
//  Copyright © 2018年 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 录音功能管理者
 */
@interface RecorderManager : NSObject

@property (nonatomic, strong) void(^recordingBlock)(NSInteger level);


+ (instancetype)shared;

- (void)record;

- (void)stop:(void(^)(NSTimeInterval time, NSURL *url))completion;

- (void)playWithUrl:(NSURL *)url completionBlock:(void(^)())completion;

- (void)pauseWithUrl:(NSURL *)url;

@end

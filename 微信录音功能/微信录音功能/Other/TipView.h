//
//  TipView.h
//  微信录音功能
//
//  Created by 树清吴 on 2018/4/16.
//  Copyright © 2018年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TipStateNormal,
    TipStateRecording,
    TipStateCancel,
    TipStateTimeShort,
} TipState;

@interface TipView : UIView

@property (nonatomic, assign) TipState state;

@property (nonatomic, assign) CGFloat volumeCount;

@property (nonatomic, strong) UIColor *maskBGColor;
@property (nonatomic, assign) CGFloat maskAlpha;


- (void)setupUI;

//- (void)show:(TipState)state;

@end

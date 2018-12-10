//
//  TipView.m
//  微信录音功能
//
//  Created by 树清吴 on 2018/4/16.
//  Copyright © 2018年 BF. All rights reserved.
//

#import "TipView.h"


/**
 正在录音view
 */
@interface TipRecordingView : TipView

@property (weak, nonatomic) IBOutlet UIImageView *soundImgView;
@property (nonatomic, strong) UIView *maskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintConstant;

@end
@implementation TipRecordingView

- (void)setupUI {
    [super setupUI];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.soundImgView addSubview:self.maskView];
    
    self.maskView.backgroundColor = self.maskBGColor;
//    self.maskView.alpha = self.maskAlpha;
    
    self.soundImgView.clipsToBounds = YES;
    self.soundImgView.contentMode = UIViewContentModeBottom;
    
    self.heightConstraintConstant.constant = 3;
}

- (void)setVolumeCount:(CGFloat)volumeCount {
    [super setVolumeCount:volumeCount];
    
    CGFloat itemHeight = 2;
    CGFloat itemPadding = 3;
    
//    NSInteger itemCount = 9;
    
    CGFloat height = volumeCount * (itemHeight + itemPadding);

    
    self.heightConstraintConstant.constant = height;
    [self setNeedsLayout];

}

@end

/**
 文字加图片提示view
 */
@interface TipImageTextView : TipView

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation TipImageTextView

- (void)setupUI {
    [super setupUI];
    
    self.imgView.contentMode = UIViewContentModeCenter;
    
    if(self.state == TipStateCancel) {
        self.label.text = @"松开手指，取消发送";
        self.imgView.image = [UIImage imageNamed:@"ic_release_to_cancel"];
        self.label.backgroundColor = [UIColor redColor];
        
    } else {
        self.label.text = @"录音时间太短";
        self.imgView.image = [UIImage imageNamed:@"ic_record_too_short"];
    }
}

@end


@interface TipView ()

@property (nonatomic, strong) TipView *previousSubview;


@end

@implementation TipView


- (instancetype)initWithState:(TipState)state {
    
    // FIXME: 创建抽象类问题
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    self = [nib instantiateWithOwner:nil options:nil].lastObject;

    _state = state;
    
    [self setupUI];
    
    
    return self;
}

- (void)setState:(TipState)state {
    _state = state;
    
    [self.previousSubview removeFromSuperview];
    
    if (state == TipStateRecording) {
        self.previousSubview = [[TipRecordingView alloc] initWithState:state];
    } else {
        self.previousSubview = [[TipImageTextView alloc] initWithState:state];
    }
    
    self.previousSubview.frame = self.bounds;
    
    [self addSubview:self.previousSubview];
    
}

- (void)setVolumeCount:(CGFloat)volumeCount {
    _volumeCount = volumeCount;
    
    if (![self.previousSubview isKindOfClass:[TipRecordingView class]]) {
        return;
    }
    
    self.previousSubview.volumeCount = volumeCount;
}


//- (void)show:(TipState)state {
//    if (state == TipStateRecording) {
//         [[TipRecordingView alloc] initWithState:0];
//    }
//    
//    [[TipImageTextView alloc] initWithState:state];
//}

- (void)setupUI {
    
    UIView *shadowVw = [[UIView alloc] initWithFrame:self.bounds];
    
    shadowVw.backgroundColor = [UIColor blackColor];
    shadowVw.alpha = 0.5;
    
    self.maskAlpha = shadowVw.alpha;
    self.maskBGColor = shadowVw.backgroundColor;
    
    [self insertSubview:shadowVw atIndex:0];

}

@end

//
//  AudioCell.m
//  微信录音功能
//
//  Created by 树清吴 on 2018/4/12.
//  Copyright © 2018年 BF. All rights reserved.
//

#import "AudioCell.h"
#import "RecorderManager.h"

@interface AudioCell ()

@property (nonatomic, strong) IBOutlet UIButton *playSoundBtn;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *btnWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation AudioCell

+ (instancetype)audioCell:(UITableView *)tableVw {
    
    static NSString *reusedID = @"reusedID";
    
    AudioCell *cell = [tableVw dequeueReusableCellWithIdentifier:reusedID];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"AudioCell" owner:nil options:nil].lastObject;
    }
    
    return cell;
}

- (void)setModel:(AudioModel *)model {
    _model = model;
    
    CGFloat startLength = 50;
    CGFloat length = self.bounds.size.width * 0.6 - startLength;
    CGFloat width = startLength + length * (model.time / 60);
    self.btnWidthConstraint.constant = width;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%zd\"", (NSInteger)model.time];
    
    [self setNeedsLayout];
}

- (IBAction)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (!sender.selected) {
        // 停止播放
        [[RecorderManager shared] pauseWithUrl:self.model.url];
    } else {
        [[RecorderManager shared] playWithUrl:self.model.url completionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.selected = NO;
            });
        }];
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.playSoundBtn.layer.cornerRadius = 5;
    self.playSoundBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

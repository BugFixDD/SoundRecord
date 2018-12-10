//
//  AudioCell.h
//  微信录音功能
//
//  Created by 树清吴 on 2018/4/12.
//  Copyright © 2018年 BF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioModel.h"

@interface AudioCell : UITableViewCell

@property (nonatomic, strong) AudioModel *model;


+ (instancetype)audioCell:(UITableView *)tableVw;

@end

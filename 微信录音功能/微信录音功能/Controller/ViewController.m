//
//  ViewController.m
//  微信录音功能
//
//  Created by 树清吴 on 2018/4/12.
//  Copyright © 2018年 BF. All rights reserved.
//

#import "ViewController.h"
#import "RecorderManager.h"
#import "AudioModel.h"
#import "AudioCell.h"
#import "TipView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableVw;

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint previousPoint;

@property (nonatomic, strong) TipView *tipVw;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setupUI];
    
    [self.recordBtn addGestureRecognizer:self.pan];
    self.pan.delegate = self;
}

// MARK: 监听方法
- (IBAction)record:(UIButton *)sender {
    [RecorderManager shared].recordingBlock = ^(NSInteger level) {
        self.tipVw.volumeCount = level;
    };
    [[RecorderManager shared] record];
    self.tipVw.hidden = NO;
    self.tipVw.state = TipStateRecording;
}

- (IBAction)cancelRecord:(UIButton *)sender {
    [[RecorderManager shared] stop:^(NSTimeInterval time, NSURL *url) {
        if (time < 1) {
            self.tipVw.state = TipStateTimeShort;
            self.tipVw.hidden = NO;
            
            [self dismissTipView];
            return ;
        }
        
        AudioModel *model = [AudioModel new];
        model.time = time;
        model.url = url;
//        NSLog(@"%f", time);
        [self.dataList addObject:model];
        self.tipVw.hidden = YES;
    }];
    
    [self.tableVw reloadData];
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    self.tipVw.hidden = NO;
    if (self.previousPoint.y >= [sender translationInView:self.view].y) {
        // 向上滑动
        NSLog(@"松开手指，取消发送");
        self.tipVw.state = TipStateCancel;
    } else {
        NSLog(@"录音");
        self.tipVw.state = TipStateRecording;
    }
    
    self.previousPoint = [sender translationInView:self.view];
    
    [self panGestureEnd];
    
}

- (void)panGestureEnd {
    if (self.pan.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
//    [self.tipVw removeFromSuperview];
    self.tipVw.hidden = YES;
    
    if (self.tipVw.state == TipStateRecording) {
        [self cancelRecord:self.recordBtn];
    } else if (self.tipVw.state == TipStateCancel) {
        
    }
}

- (void)dismissTipView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.tipVw.alpha = 0;
        } completion:^(BOOL finished) {
            self.tipVw.alpha = 1;
            self.tipVw.hidden = YES;
        }];
    });
}

// MARK: TableViewDelegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AudioCell *cell = [AudioCell audioCell:tableView];
    
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}



// MARK: 设置方法
- (void)setupUI {
    self.tableVw.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableVw.allowsSelection = NO;
    
    self.recordBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.recordBtn.layer.borderWidth = 1;
    self.recordBtn.layer.cornerRadius = 3;
    
    self.tipVw = [[TipView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.tipVw.center = self.view.center;
    [self.view addSubview:self.tipVw];
    
}

- (void)addGesture {
    
}

// MARK: 懒加载

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray arrayWithCapacity:4];
    }
    return _dataList;
}

- (UIPanGestureRecognizer *)pan {
    if (_pan == nil) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    }
    return _pan;
}

@end

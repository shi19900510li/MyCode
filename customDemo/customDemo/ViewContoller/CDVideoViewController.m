//
//  CDVideoViewController.m
//  customDemo
//
//  Created by shendeMac on 2018/9/12.
//  Copyright © 2018年 sandsyu. All rights reserved.
//

#import "CDVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface CDVideoViewController ()
@property (nonatomic,strong) AVPlayer *player;
@end

@implementation CDVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1. AVPlayerViewController 播放直接全屏
    NSString *imgSrc = [[NSBundle mainBundle] pathForResource:@"qnyn_juqing" ofType:@".mp4"];
    _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:imgSrc]];
    AVPlayerViewController *vc = [[AVPlayerViewController alloc]init];
    vc.player = _player;
    [self presentViewController:vc animated:YES completion:^ {
        [vc.player play];
    }];
}


@end

//
//  ViewController.m
//  MyDemo
//
//  Created by 石伟东 on 2017/11/7.
//  Copyright © 2017年 石伟东. All rights reserved.
//

#import "ViewController.h"
#import "CPVideoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)touchToTakeVideo:(id)sender {
    CPVideoViewController *cp = [[CPVideoViewController alloc]init];
    cp.HSeconds = 10;
    cp.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            NSURL *videoURL = item;
            // 视频url
        } else {
            // 图片
        }
    };
    [self presentViewController:cp animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  CPVideoViewController.h
//  MyDemo
//
//  Created by 石伟东 on 2017/11/7.
//  Copyright © 2017年 石伟东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoneBlock)(id item);
@interface CPVideoViewController : UIViewController

@property (nonatomic, assign) NSInteger HSeconds;

@property (nonatomic, copy)  DoneBlock takeBlock;
@end
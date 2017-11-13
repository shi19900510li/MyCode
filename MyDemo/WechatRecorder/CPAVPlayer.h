//
//  CPAVPlayer.h
//  MyDemo
//
//  Created by 石伟东 on 2017/11/7.
//  Copyright © 2017年 石伟东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPAVPlayer : UIView

@property (nonatomic, strong) NSURL *videoUrl;

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url;
- (void)stopPlayer;
@end

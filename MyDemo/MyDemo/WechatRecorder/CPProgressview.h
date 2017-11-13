//
//  CPProgressview.h
//  MyDemo
//
//  Created by 石伟东 on 2017/11/7.
//  Copyright © 2017年 石伟东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPProgressview : UIView

/**
 最长时间
 */
@property (nonatomic, assign) NSInteger timeMax;

- (void)clearProgress;
@end

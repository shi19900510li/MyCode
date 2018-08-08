//
//  HYViewController.h
//  自定义导航控制器
//
//  Created by Sekorm on 16/4/22.
//  Copyright © 2016年 HelloYeah. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, HYHidenControlOptions) {

    HYHidenControlOptionLeft = 0x01,
    HYHidenControlOptionTitle = 0x01 << 1,
    HYHidenControlOptionRight = 0x01 << 2,
    
};

@interface HYViewController : UIViewController

- (void)setKeyScrollView:(UIScrollView * )keyScrollView scrolOffsetY:(CGFloat)scrolOffsetY options:(HYHidenControlOptions)options;

@end

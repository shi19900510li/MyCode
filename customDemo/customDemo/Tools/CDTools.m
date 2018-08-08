//
//  CDTools.m
//  customDemo
//
//  Created by shendeMac on 2017/12/25.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "CDTools.h"

@implementation CDTools
//进入全屏
+ (void)begainFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}
// 退出全屏
+ (void)endFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end

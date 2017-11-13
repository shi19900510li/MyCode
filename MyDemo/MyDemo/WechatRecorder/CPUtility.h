//
//  CPUtility.h
//  MyDemo
//
//  Created by 石伟东 on 2017/11/7.
//  Copyright © 2017年 石伟东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CPUtility : NSObject

+ (void)showTextDialog:(UIView *)view;
+ (void)showProgressDialog:(UIView *)view;
+ (void)showProgressDialog:(UIView *)view text:(NSString *)text;
+ (void)showProgressDialogText:(NSString *)text;
+ (void)hideProgressDialog:(UIView *)view;
+ (void)hideProgressDialog;
+ (void)showCustomDialog:(UIView *)view title:(NSString *)text;
+ (void)showAllTextDialog:(UIView *)view  Text:(NSString *)text;
@end

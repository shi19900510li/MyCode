//
//  CPUtility.m
//  MyDemo
//
//  Created by 石伟东 on 2017/11/7.
//  Copyright © 2017年 石伟东. All rights reserved.
//

#import "CPUtility.h"
#import "DLHDActivityIndicator.h"
#import "MBProgressHUD.h"
@implementation CPUtility
+ (void)showTextDialog:(UIView *)view {
    //初始化进度框，置于当前的View当中
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    //    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍等";
    
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
    }];
}

+ (void)showProgressDialog:(UIView *)view {
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    DLHDActivityIndicator *indicator = [[DLHDActivityIndicator alloc] init];
    indicator.window = view;
    [indicator showWithLabelText:@"正在加载"];
}

+ (void)showProgressDialog:(UIView *)view text:(NSString *)text {
    
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    DLHDActivityIndicator *indicator = [[DLHDActivityIndicator alloc] init];
    indicator.window = view;
    [indicator showWithLabelText:text];
}

+ (void)showProgressDialogText:(NSString *)text {
    DLHDActivityIndicator *indicator = [DLHDActivityIndicator shared];
    [indicator showWithLabelText:text];
}

+ (void)hideProgressDialog:(UIView *)view {
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    
}

+ (void)hideProgressDialog {
    
    [DLHDActivityIndicator hideActivityIndicator];
}

+ (void)showCustomDialog:(UIView *)view title:(NSString *)text {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = text;
    HUD.labelFont = [UIFont systemFontOfSize:14.0];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save_complete"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)showAllTextDialog:(UIView *)view  Text:(NSString *)text{
    if (!view) {
        return;
    }
    if ([view isKindOfClass:[UITableView class]]) {
        view = view.superview;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.margin = 12.f;
    HUD.detailsLabelText = text;
    HUD.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //    HUD.yOffset = 150.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}
@end

//
//  CDShareViewController.m
//  customDemo
//
//  Created by shendeMac on 2017/12/29.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "CDShareViewController.h"
#import <Social/Social.h>
#import "CDSharemanager.h"
@interface CDShareViewController ()

@end

@implementation CDShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)testShare {
    NSString *textToShare = @"文本内容";
    UIImage *imageToShare = [UIImage imageNamed:@"qq_music"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://www.baidu.com"];
    NSArray *activityItems = @[textToShare,imageToShare,urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                                            applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];
    
    //给activityVC的属性completionHandler写一个block。
    //用以UIActivityViewController执行结束后，被调用，做一些后续处理。
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray * returnedItems, NSError * activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            NSLog(@"completed");
        }
        else
        {
            NSLog(@"cancel");
        }
    };
    
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityVC.completionWithItemsHandler = myBlock;
    UIViewController * rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:activityVC animated:TRUE completion:nil];
}
- (IBAction)SLShare {
    //1.判断是否可用
    NSString *wechat = @"com.tencent.xin.sharetimeline";
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"不支持微信~~~");
    }
    //2.创建分享控制器
    SLComposeViewController *slc = [SLComposeViewController composeViewControllerForServiceType:wechat];
    if (!slc) {
        NSLog(@"未安装微信~~~");
    }
    //3.设置分享图片、url、文字
    [slc setInitialText:@"神的iPhone~~~"];
    [slc addImage:[UIImage imageNamed:@"qq_music"]];
    //4.显示
    [self presentViewController:slc animated:YES completion:^{
        
    }];
    //5.监听发送
    slc.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"点击了取消~~~");
        } else if (result == SLComposeViewControllerResultDone) {
            NSLog(@"点击了确定~~~");
        }
    };
}
- (IBAction)wechatShare {
    [CDSharemanager shareInstance].shareDict = @{share_Key_Text:@"毛毛毛毛~~~",share_Key_Title:@"mao",share_Key_Url:@""};
    [[CDSharemanager shareInstance] shareToWXFriend];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

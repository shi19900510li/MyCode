//
//  CDSharemanager.m
//  customDemo
//
//  Created by shendeMac on 2018/1/30.
//  Copyright © 2018年 sandsyu. All rights reserved.
//

#import "CDSharemanager.h"
#define AppId @"wx0c96d8611cfb6f57"

@implementation CDSharemanager

+ (instancetype)shareInstance {
    static CDSharemanager *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[CDSharemanager alloc]init];
    });
    return share;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    if ([url.absoluteString hasPrefix:AppId])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (void)shareToWXFriend
{
    NSString *content = [self.shareDict objectForKey:share_Key_Text];
    [self sendTextContent:content scene:WXSceneSession];
}

- (void)sendTextContent:(NSString *)str scene:(int)aScene
{
    if (![WXApi isWXAppInstalled])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提醒"
                                                       message:@"您还没有安装微信客户端"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    WXWebpageObject *webr=[[WXWebpageObject alloc] init];
    webr.webpageUrl = [self.shareDict objectForKey:share_Key_Url];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [self.shareDict objectForKey:share_Key_Title];;
    message.mediaObject = webr;
    
    req.text = str;
    req.message = message;
    req.bText = YES;//文字类型需要yes，其他是no
    req.scene = aScene;
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0) {
            UIAlertView *weixiaccess=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [weixiaccess show];
        }
        else
        {
            UIAlertView *weixifail=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [weixifail show];
        }
    }
}

@end

//
//  CDSharemanager.h
//  customDemo
//
//  Created by shendeMac on 2018/1/30.
//  Copyright © 2018年 sandsyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#define share_Key_Title @"title"
#define share_Key_Text @"text"
#define share_Key_Url @"url"
#define share_Key_Image @"image"

@interface CDSharemanager : NSObject <WXApiDelegate>
@property (nonatomic, retain) NSDictionary *shareDict;// 分享字典，文本、图片、URL

+ (instancetype)shareInstance;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)shareToWXFriend;

@end

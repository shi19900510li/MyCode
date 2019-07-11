//
//  AppDelegate.m
//  customDemo
//
//  Created by joker on 2017/5/22.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "CDSharemanager.h"
#import <JSPatchPlatform/JSPatch.h>

#define AppId @"wx0c96d8611cfb6f57"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WXApi registerApp:AppId];
    NSLog(@"sandPath:%@",NSHomeDirectory());
    // JSPatch接入
//    [JSPatch testscjsinbund];
    [JSPatch startWithAppKey:@"1c8601f1552a6eab"];
    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDAyVdH7h82k19K/zrXdhFEZ+H5\nR17/DRJGV5cjObA2cm+Gt+eKSKRLKDm+UCsHX8Kb5MmLXS8x9I81e0VkZ+Vlt2o/\n62rRqwLTx3ciUMf4gNCDkQPglZqX0REW5zbQU887GF4/XlRjX83btAdh7JX1u3Zh\n7sD9+ThYP3pq4IYWKQIDAQAB\n-----END PUBLIC KEY-----"];
#ifdef DEBUG
    [JSPatch setupDevelopment]; // 开发预览
    [JSPatch showDebugView];
#endif
    [JSPatch sync];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[CDSharemanager shareInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[CDSharemanager shareInstance] handleOpenURL:url];
}

@end

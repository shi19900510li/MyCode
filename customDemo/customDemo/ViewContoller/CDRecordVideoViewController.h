//
//  CDRecordVideoViewController.h
//  customDemo
//
//  Created by shendeMac on 2017/12/15.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDRecordVideoDelegate <NSObject>

/**
 录制完成回调

 @param filePath 路径
 */
- (void)finishWechatShortVideoCapture:(NSURL *)filePath showImage:(UIImage *)image;

@end

@interface CDRecordVideoViewController : UIViewController

@property (nonatomic,assign) id <CDRecordVideoDelegate> delegate;

/**
 存储路径
 */
@property (nonatomic,copy) NSString *filePath;

/**
 录制时长
 */
@property (nonatomic,assign) NSInteger recordTime;

/**
 是否存到相册
 */
@property (nonatomic,assign) BOOL saveToPhotos;
@end

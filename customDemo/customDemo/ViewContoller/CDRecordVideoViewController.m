//
//  CDRecordVideoViewController.m
//  customDemo
//
//  Created by shendeMac on 2017/12/15.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "CDRecordVideoViewController.h"
#import "SCRecorder.h"
#import "MBProgressHUD.h"
#import "CDTools.h"
#import "HProgressView.h"

@interface CDRecordVideoViewController () <SCRecorderDelegate,SCAssetExportSessionDelegate,MBProgressHUDDelegate>
{
    SCRecorder *_recorder;
    
    SCPlayer *_player;
    
    //Video filepath
    NSURL *VIDEO_OUTPUTFILE;
    NSURL *newUrl;
}
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIView *videoPreview;
@property (strong, nonatomic) IBOutlet UIView *recordBackView;
@property (strong, nonatomic) SCRecorderToolsView *focusView;
@property (nonatomic,strong) MBProgressHUD *progress;
@property (strong, nonatomic) IBOutlet HProgressView *cirecleProgress;
@property (weak, nonatomic) IBOutlet UIButton *closePlayer;

@property (weak, nonatomic) IBOutlet UIButton *selectVideo;


@end

static CGFloat recordBackHeight = 150;

@implementation CDRecordVideoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.recordTime = 10;
        self.saveToPhotos = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordButton.layer.cornerRadius = 30.0;
    self.recordButton.layer.masksToBounds = YES;
    self.recordButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.recordButton.layer.borderWidth = 2.0;
    
    self.cirecleProgress.layer.cornerRadius = self.cirecleProgress.frame.size.width/2.0;
    self.cirecleProgress.layer.masksToBounds = YES;
    
    self.closePlayer.hidden = YES;
    self.selectVideo.hidden = YES;
    
    // 存储路径
    VIDEO_OUTPUTFILE = [NSURL fileURLWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:@"localVideo.mp4"]];
    
    [self configRecorder];
    
    [self updateConstaints];
    
    self.recordButton.enabled = NO;
    
    [self performSelector:@selector(canRecordButtonEnabled) withObject:nil afterDelay:1];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 设置播放层
    [_recorder previewViewFrameChanged];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 启用屏幕旋转
//    [CDTools begainFullScreen];
    // 设置播放session
    [self prepareSession];
    // 开始运行
    [_recorder startRunning];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_recorder stopRunning];
    // 关闭屏幕旋转
//    [CDTools endFullScreen];
    // 移除进度条
    [self.cirecleProgress clearProgress];
    [self.cirecleProgress removeFromSuperview];
}
- (void)dealloc {
    _recorder.previewView = nil;
    [_player pause];
    _player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 更新portrait方向约束
- (void)updateConstaints {
    [self.videoPreview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    [self.recordBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.videoPreview);
        make.top.equalTo(self.videoPreview.mas_top).offset(self.videoPreview.frame.size.height - 150);
    }];
    [self.recordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recordBackView);
        make.width.and.height.equalTo(@60);
    }];
    [self.cirecleProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recordBackView);
        make.width.and.height.equalTo(@67);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordBackView.mas_centerX);
        make.top.equalTo(self.recordBackView).offset(10);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoPreview).offset(10);
        make.top.equalTo(self.videoPreview).offset(20);
    }];
    [self.closePlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBackView.mas_centerY);
        make.right.equalTo(self.recordBackView).offset(-50);
        make.width.height.equalTo(@70);
    }];
    [self.selectVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBackView.mas_centerY);
        make.left.equalTo(self.recordBackView).offset(50);
        make.width.height.equalTo(@70);
    }];
    
    [self.focusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.bottom.equalTo(self.view).offset(-150);
        make.left.right.equalTo(self.view);
    }];
}

#pragma mark - recorder 配置
- (void)configRecorder {
    _recorder = [SCRecorder recorder];
    //    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.captureSessionPreset = AVCaptureSessionPreset1280x720;
    _recorder.fastRecordMethodEnabled = YES; // 减少压缩时间
    _recorder.maxRecordDuration = CMTimeMake(30 * self.recordTime, 30); // 录制的最大时长
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES; // 旋转屏幕
    
    UIView *previewView = self.videoPreview;
    _recorder.previewView = previewView;
    
    // 配置聚焦
    self.focusView = [[SCRecorderToolsView alloc] init];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"WechatShortVideo_scan_focus"];
    _recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        
        _recorder.session = session;
    }
}

- (void)canRecordButtonEnabled {
    self.recordButton.enabled = YES;
}

#pragma mark 取消录制
- (IBAction)cancelRecord {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 保存录制
- (void)saveRecord {
    [_player pause];
    self.timeLabel.text = @"";
    self.recordBackView.hidden = YES;
    self.recordButton.hidden = YES;
    [self.cirecleProgress clearProgress];
    __block UIImage *showImage;
    [_recorder capturePhoto:^(NSError * _Nullable error, UIImage * _Nullable image) {
        showImage = image;
    }];
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        if (error == nil) {
            //            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil];
            long long size = [attributes fileSize];
            NSLog(@"保存沙盒成功  大小：%.1fKB",size / 1000.0);
            
            if (self.saveToPhotos) {
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(finishWechatShortVideoCapture:showImage:)]) {
                    [self.delegate finishWechatShortVideoCapture:VIDEO_OUTPUTFILE showImage:showImage];
                }
            }];
            
        } else {
            NSLog(@"保存失败~~");
        }
    };
    
    //    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSLog(@"本地视频存储路径：%@",VIDEO_OUTPUTFILE);
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    exportSession.videoConfiguration.preset = SCPresetMediumQuality;
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 0;
    //    exportSession.videoConfiguration.composition = [self getVideoComposition:_recorder.session.assetRepresentingSegments];
    
    exportSession.outputUrl = VIDEO_OUTPUTFILE;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.delegate = self;
    
    self.progress = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    self.progress.delegate = self;
    self.progress.labelText = @"压缩中...";
    self.progress.mode = MBProgressHUDModeDeterminate;
    
    
    CFTimeInterval time = CACurrentMediaTime();
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progress hide:YES];
            });
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
            
            //            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            completionHandler(exportSession.outputUrl, exportSession.error);
        }];
    });
    
}

#pragma mark 重新录制
- (IBAction)closeVideoPlayer {
    [_player pause];
    _player = nil;
    for (UIView *view in self.videoPreview.subviews) {
        if (view.tag == 400) {
            [view removeFromSuperview];
        }
    }
    self.closePlayer.hidden = YES;
    self.selectVideo.hidden = YES;
    self.cirecleProgress.hidden = NO;
    self.recordBackView.hidden = NO;
    self.recordButton.hidden = NO;
    [self.cirecleProgress reDrawRect];
    self.timeLabel.text = @"";
    
    [self cancelCaptureWithSaveFlag:NO];
}

#pragma mark 选择录像
- (IBAction)selectCurrentVideo {
    [self saveRecord];
}

#pragma mark 终止录制
- (void)tapTerminateVideo {
    [self cancelCaptureWithSaveFlag:YES];
}

#pragma mark 播放视频
- (void)showPlayerEdit {
    _player = [SCPlayer player];
    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.tag = 400;
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.frame = self.videoPreview.bounds;
    playerView.autoresizingMask = self.videoPreview.autoresizingMask;
    [self.videoPreview addSubview:playerView];
    _player.loopEnabled = YES;
    
    [_player setItemByAsset:_recorder.session.assetRepresentingSegments];
    [_player play];
    
    self.closePlayer.hidden = NO;
    self.selectVideo.hidden = NO;
    self.timeLabel.text = @"";
    [self.cirecleProgress clearProgress];
    [self.videoPreview bringSubviewToFront:self.closePlayer];
    [self.videoPreview bringSubviewToFront:self.selectVideo];
    
}

- (void)cancelCaptureWithSaveFlag:(BOOL)saveFlag {
    [_recorder pause:^{
        if (saveFlag) {
            //Preview and save
            [self performSelector:@selector(showPlayerEdit) withObject:nil afterDelay:0.5];
        } else {
            //retake prepare
            SCRecordSession *recordSession = _recorder.session;
            if (recordSession != nil) {
                _recorder.session = nil;
                [recordSession cancelSession:nil];
            }
            [self prepareSession];
        }
    }];
}
#pragma mark 开始录制视频
- (IBAction)recordVideo {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTerminateVideo)];
    [self.cirecleProgress addGestureRecognizer:tap];
    [_recorder record];
    [CDTools endFullScreen];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if (error == nil) {
        NSLog(@"保存相机成功！！~！");
    } else {
        NSLog(@"保存相机失败");
    }
}

#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    //update progressBar
    NSLog(@"didAppendVideoSampleBufferInSession--%lld,%lld,%lld",recordSession.duration.value,recordSession.segmentsDuration.value,recordSession.currentSegmentDuration.value);
    NSInteger value = ceilf(recordSession.duration.value / 1000000000.0);
    if (value == 0) {
        self.cirecleProgress.timeMax = self.recordTime;
        self.recordButton.hidden = YES;
        self.recordBackView.hidden = YES;
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld",value];
    }
    //    [self refreshProgressViewLengthByTime:recordSession.duration];
}

- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
    //confirm capture
    //preview and save video
    NSLog(@"didCompleteSession--success~~");
    [self performSelector:@selector(showPlayerEdit) withObject:nil afterDelay:0.2];
}

#pragma mark SCAssetExportSessionDelegate
- (void)assetExportSessionDidProgress:(SCAssetExportSession *__nonnull)assetExportSession {
    dispatch_async(dispatch_get_main_queue(), ^{
        float progress = assetExportSession.progress;
        self.progress.progress = progress;
    });
}

#pragma mark rotation
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        //清除subviews
        NSLog(@"home键靠右");
        [self.videoPreview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
        [self.recordBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.videoPreview);
            make.left.equalTo(self.videoPreview.mas_left).offset(self.videoPreview.frame.size.width - 150);
            make.top.equalTo(self.videoPreview.mas_top);
        }];
        [self.recordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.recordBackView);
            make.width.and.height.equalTo(@60);
        }];
        [self.cirecleProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.recordBackView);
            make.width.and.height.equalTo(@67);
        }];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.recordBackView.mas_centerY);
            make.left.equalTo(self.recordBackView).offset(10);
        }];
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoPreview).offset(20);
            make.bottom.equalTo(self.videoPreview).offset(-10);
        }];
        [self.closePlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recordBackView);
            make.top.equalTo(self.recordBackView).offset(50);
            make.width.height.equalTo(@70);
        }];
        [self.selectVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recordBackView);
            make.bottom.equalTo(self.recordBackView).offset(-50);
            make.width.height.equalTo(@70);
        }];
        
        [self.focusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(80);
            make.right.equalTo(self.view).offset(-150);
            make.top.bottom.equalTo(self.view);
        }];
    }
    if (orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
    {
        //清除subviews
        NSLog(@"home键靠左");
        [self.videoPreview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
        [self.recordBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.videoPreview);
            make.left.equalTo(self.videoPreview.mas_left).offset(self.videoPreview.frame.size.width - 150);
            make.top.equalTo(self.videoPreview.mas_top);
        }];
        [self.recordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.recordBackView);
            make.width.and.height.equalTo(@60);
        }];
        [self.cirecleProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.recordBackView);
            make.width.and.height.equalTo(@67);
        }];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.recordBackView.mas_centerY);
            make.left.equalTo(self.recordBackView).offset(10);
        }];
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoPreview).offset(20);
            make.bottom.equalTo(self.videoPreview).offset(-10);
        }];
        [self.closePlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recordBackView);
            make.top.equalTo(self.recordBackView).offset(50);
            make.width.height.equalTo(@70);
        }];
        [self.selectVideo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recordBackView);
            make.bottom.equalTo(self.recordBackView).offset(-50);
            make.width.height.equalTo(@70);
        }];
        
        [self.focusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(80);
            make.right.equalTo(self.view).offset(-150);
            make.top.bottom.equalTo(self.view);
        }];
        
    }
    if (orientation == UIInterfaceOrientationPortrait)
    {
        NSLog(@"home键靠下");
        [self updateConstaints];
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //清除subviewse distantFuture]];
//        [CPToastManager showToastInView:self.view withTitle:@"请勿在此方向拍摄" afterDelay:1 offset:0];
    }
}


@end


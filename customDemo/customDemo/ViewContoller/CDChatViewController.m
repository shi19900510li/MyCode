//
//  CDChatViewController.m
//  customDemo
//
//  Created by shendeMac on 2019/7/11.
//  Copyright © 2019 sandsyu. All rights reserved.
//

#import "CDChatViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface CDChatViewController ()
@property (nonatomic,strong) IJKFFMoviePlayerController *player;
@end

@implementation CDChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DEBUG" style:UIBarButtonItemStylePlain target:self action:@selector(debugChange:)];
    
    // 拉流地址
    NSURL *url = [NSURL URLWithString:@"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov"];
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //    [options setOptionIntValue:2 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    //    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    options.showHudView = YES;
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.player prepareToPlay];
    [self.player play];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [self.player pause];
    [self.player stop];
    [self.player shutdown];
}

- (void)debugChange:(UIBarButtonItem *)item {
    self.player.shouldShowHudView = !self.player.shouldShowHudView;
}

@end

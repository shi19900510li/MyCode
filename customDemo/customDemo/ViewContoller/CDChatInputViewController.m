//
//  CDChatInputViewController.m
//  customDemo
//
//  Created by shendeMac on 2019/7/11.
//  Copyright © 2019 sandsyu. All rights reserved.
//

#import "CDChatInputViewController.h"
#import "YHExpressionKeyboard.h"

@interface CDChatInputViewController () <YHExpressionKeyboardDelegate>

@end

@implementation CDChatInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *back = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:back];
    YHExpressionKeyboard *v = [[YHExpressionKeyboard alloc] initWithViewController:self aboveView:back delegate:self];
    [self.view addSubview:v];
}


- (void)didCancelRecordingVoice { 
    
}

- (void)didDragInside:(BOOL)inside { 
    
}

- (void)didStartRecordingVoice { 
    
}

- (void)didStopRecordingVoice { 
    
}

- (void)didTapSendBtn:(NSString *)text { 
    
}

@end

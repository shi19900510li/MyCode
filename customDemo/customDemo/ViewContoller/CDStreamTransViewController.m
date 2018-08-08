//
//  CDStreamTransViewController.m
//  customDemo
//
//  Created by shendeMac on 2018/1/31.
//  Copyright © 2018年 sandsyu. All rights reserved.
//

#import "CDStreamTransViewController.h"

@interface CDStreamTransViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *firstImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;
@property (strong, nonatomic) IBOutlet UIButton *uploadImages;

@property (nonatomic,assign) UIImageView *currentImage;

@property (nonatomic,strong) UIImagePickerController *picker;

@property (nonatomic,strong) NSMutableArray *imgDatas;

@end

@implementation CDStreamTransViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.firstImage addGestureRecognizer:[self getTapGesture]];
    [self.secondImage addGestureRecognizer:[self getTapGesture]];
}

- (UIGestureRecognizer *)getTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(initImagePicker)];
    return tap;
}

- (void)initImagePicker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _picker.allowsEditing =YES;
        _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    [self presentViewController:_picker animated:YES completion:nil];
}

- (IBAction)uploadTwoImage {
    
}

#pragma mark  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = [self compressOriginalImage:image toMaxDataSizeKBytes:500];
    
    [_imgDatas addObject:imgData];
}

- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    
    CGFloat dataKBytes = data.length/1024.0;
    
    CGFloat maxQuality = 0.9f;
    
    CGFloat lastData = dataKBytes;
    
    while (dataKBytes > size && maxQuality > 0.05) {
        
        maxQuality = maxQuality - 0.05f;
        
        data = UIImageJPEGRepresentation(image, maxQuality);
        
        dataKBytes = data.length / 1024.0;
        
        if (lastData == dataKBytes) {
            
            break;
            
        }else{
            
            lastData = dataKBytes;
            
        }
    }
    return data;
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

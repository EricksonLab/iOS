//
//  ViewController.m
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/2/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ViewController.h"
#import "ELCameraMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_currentImageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showImage:(UIButton *)sender {
    UIImage *currentImage = [self.cameraMonitor getCurrentImage];
    if (!currentImage) NSLog(@"No Image");
    else _currentImageView.image = currentImage;
}

- (IBAction)start:(UIButton *)sender {
    if (!self.cameraMonitor) {
        self.cameraMonitor = [[ELCameraMonitor alloc] initWithPreview];
        [self.view addSubview:self.cameraMonitor];
        [self.cameraMonitor startCamera];
    }
}

- (IBAction)stop:(UIButton *)sender {
    if (self.cameraMonitor) {
        [self.cameraMonitor stopCamera];
        [self.cameraMonitor removeFromSuperview];
        self.cameraMonitor = nil;
    }
}
@end

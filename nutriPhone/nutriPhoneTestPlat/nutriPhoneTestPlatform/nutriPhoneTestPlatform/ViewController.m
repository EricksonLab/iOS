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

-(void) measureOnce {
    UIImage *currentImage = [self.cameraMonitor getCurrentImage];
    if (!currentImage) NSLog(@"No Image");
    else _currentImageView.image = currentImage;
}


- (IBAction)start:(UIButton *)sender {
    if (!self.cameraMonitor) {
        _cameraMonitor = [[ELCameraMonitor alloc] init];
        _testVideoPreview = [[ELTestVideoPreview alloc] initTestView];
      //  [self.testVideoPreview
        [self.view addSubview:_testVideoPreview];
        [_cameraMonitor startCamera];
        [_testVideoPreview buildConnectionWithCameraMonitor:_cameraMonitor];
        [_testVideoPreview setContentMode:UIViewContentModeCenter];
        measureController =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(measureOnce) userInfo:nil repeats:YES];
        [measureController fire];
    }
}

- (IBAction)stop:(UIButton *)sender {
    [measureController invalidate];
    measureController = nil;
    if (_cameraMonitor) {
        [_cameraMonitor stopCamera];
        _cameraMonitor = nil;
    }
    if (_testVideoPreview) {
        [_testVideoPreview removeFromSuperview];
        _testVideoPreview = nil;
    }
    ELImage *img = [[ELImage alloc] init];
    Byte* p=(UInt8 *)malloc(sizeof(UInt8)*20);
    p[10]=5;
    [img print:p];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [measureController invalidate];
    measureController = nil;
    if (_cameraMonitor) {
        [_cameraMonitor stopCamera];
        _cameraMonitor = nil;
    }
    if (_testVideoPreview) {
        [_testVideoPreview removeFromSuperview];
        _testVideoPreview = nil;
    }
}
@end

//
//  ViewController.m
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/2/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_currentImageView setContentMode:UIViewContentModeScaleAspectFit];
    _graphView = [[ELGraphView alloc] initDefault];
    [_graphView setBackgroundColor:[UIColor colorWithRed:20 green:20 blue:0 alpha:0.1]];
    [self.view addSubview:_graphView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) measureOnce {
    [_cameraMonitor restoreSettings];
    UIImage *currentImage = [_cameraMonitor getCurrentImage];
    ELImage *currentELImage = [_cameraMonitor getCurrentELImage];
    if (!currentImage || !currentELImage) NSLog(@"No Image");
    else {
        _currentImageView.image = currentImage;
        NSArray* dataToPlot = [NSArray arrayWithArray:[ELImageProcessor getPregResultTrend:currentELImage]];
        [_graphView updateInternalDataY:dataToPlot];
    }
    [_graphView setNeedsDisplay];
}


- (IBAction)start:(UIButton *)sender {
    if (!self.cameraMonitor) {
        _cameraMonitor = [[ELCameraMonitor alloc] init];
        [_cameraMonitor startCamera];
        if (_testVideoPreview) {
            [_testVideoPreview removeFromSuperview];
            _testVideoPreview = nil;
        }
        _testVideoPreview = [[ELTestVideoPreview alloc] initTestView];
      //  [self.testVideoPreview
        [self.view addSubview:_testVideoPreview];
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

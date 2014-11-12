//
//  ViewController.m
//  Cholesterol Test
//
//  Created by NutriPhone on 11/5/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_currentImageView setContentMode:UIViewContentModeScaleAspectFill];
    _graphView = [[ELGraphView alloc] initDefault];
    [_graphView setBackgroundColor:[UIColor colorWithRed:20 green:20 blue:0 alpha:0.1]];
    cholResultTrend = [NSMutableArray arrayWithCapacity:10];
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
     //   NSArray* dataToPlot = [NSArray arrayWithArray:[ELImageProcessor getPregResultTrend:currentELImage]];
        
        NSNumber* result = [ELImageProcessor getCholResult:currentELImage];
        _testResultLabel.text = [NSString stringWithFormat:@"Chol: %.2fmg/L",result.floatValue];
        [cholResultTrend addObject:result];
        [_graphView updateInternalDataY:cholResultTrend];
        numOfValidDatas ++;
        if (numOfValidDatas == 10) {
            NSNumber* finalResult = [self meanOf:cholResultTrend];
            [self stopTest];
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Result"
                                                          message:[NSString stringWithFormat:@"Blood Cholesterol\n%.2fmg/L",finalResult.floatValue]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
        }
    }
    [_graphView setNeedsDisplay];
}


- (IBAction)start:(UIButton *)sender {
    if (!self.cameraMonitor) {
        [self startTest];
    } else {
        [self stopTest];
    }
}

- (void)stopTest{
    [measureController setFireDate:[NSDate distantFuture]];
    cholResultTrend = [NSMutableArray arrayWithCapacity:11];
 //   measureController = nil;
    if (_cameraMonitor) {
        [_cameraMonitor stopCamera];
        _cameraMonitor = nil;
        [_controlButton setTitle:@"Start" forState:UIControlStateNormal];
        _testResultLabel.text = @"Chol Test Ready";
    }
}

-(void)startTest{
    [_graphView setViewVisionLeft:0 Top:100 Right:9 Bottom:0];
    [_graphView setGraphViewScaleMode:ELGraphViewScaleAutoY];
    numOfValidDatas = 0;
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
    [measureController setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    [_controlButton setTitle:@"Cancel" forState:UIControlStateNormal];
    _testResultLabel.text = @"Analyzing...";

}

- (IBAction)stop:(UIButton *)sender {
    
    
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

-(NSNumber *)meanOf:(NSArray *)array
{
    float runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number floatValue];
    }
    
    return [NSNumber numberWithFloat:(runningTotal / [array count])];
}

@end


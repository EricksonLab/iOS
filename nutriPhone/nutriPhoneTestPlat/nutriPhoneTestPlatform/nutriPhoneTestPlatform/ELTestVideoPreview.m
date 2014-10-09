//
//  ELTestVideoPreview.m
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-7.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import "ELTestVideoPreview.h"


@implementation ELTestVideoPreview
#pragma mark - Initialization

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (id) initTestView
{
    CGRect previewRect = CGRectMake(180, 30, 120, 90);
    return [self initWithFrame:previewRect];
}

- (id) initWithFrame:(CGRect)frame
//Initial preview at CGRect frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setToDefaults];
        self.cameraMonitor = [[ELCameraMonitor alloc ]init];
     //   self.cameraMonitor.label = 26;
     //   NSLog(@"%d",self.cameraMonitor.label);
        [self.cameraMonitor startCamera];
         //Show preview of graph
     /**    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.cameraMonitor.session];
         
         captureVideoPreviewLayer.frame = self.bounds;
         captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
         
         [self.layer addSublayer:captureVideoPreviewLayer];**/
         }
    return self;
}

#pragma mark - Settings

- (void) setToDefaults
//set all value to defaults
{
    [self setBackgroundColor:[UIColor blackColor]];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

-(void) torchOn {
    
}

-(void) torchOff {
    
}

#pragma mark - Video Control

-(void) pausePreview {
    
}

-(void) continuePreview {
    
}

-(void) reconnectPreview {
    
}



@end

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
    }
    return self;
}

#pragma mark - Settings

- (void) setToDefaults
//set all value to defaults
{
    [self setBackgroundColor:[UIColor blackColor]];
 //   self.layer.cornerRadius = 5;
    self.layer.masksToBounds = NO;
}

-(void) torchOn {
    
}

-(void) torchOff {
    
}

#pragma mark - Video Control

-(BOOL) buildConnectionWithCameraMonitor:(ELCameraMonitor *)cameraMonitor {
    if (!cameraMonitor) {
        NSLog(@"Camera monitor not defined");
        return NO;
    }
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:cameraMonitor.session];
    
    captureVideoPreviewLayer.frame = self.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.layer addSublayer:captureVideoPreviewLayer];
    
    //Restore torch status
    [cameraMonitor restoreSettings];

    
    return captureVideoPreviewLayer;
}

-(void) pausePreview {
    
}

-(void) continuePreview {
    
}

-(void) reconnectPreview {
    
}



@end

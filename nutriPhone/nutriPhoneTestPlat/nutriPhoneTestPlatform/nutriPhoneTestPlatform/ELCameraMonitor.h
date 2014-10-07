//
//  ELCameraMonitor.h
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/3/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <CoreVideo/CoreVideo.h>
#import <math.h>

typedef enum {
    FRONT = 0,
    BACK = 1,
}ELCameraType;

@interface ELCameraMonitor : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
    NSData *imageData;
    UIImage *image;
    CGRect previewRect;
    NSInteger minFrameDuration;
    UInt64 timeLastFrame,timeCurrentFrame;

    BOOL cameraOn;
    BOOL visiblePreview;
    BOOL hasImageData;
    BOOL torchOn;
    BOOL previewRectDefined;
}



@property (nonatomic, assign) AVCaptureDevicePosition cameraType;
@property (nonatomic, assign) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, assign) int label;

+ (ELCameraMonitor *) sharedInstance;
-(id) initWithDefaltSettings;
-(id) initWithCamera:(ELCameraType)camera
      torchOn:(BOOL)torch
      minFrameDuration:(NSInteger)duration;

-(void) setToDefaults;
-(void) setTorchOn:(BOOL)torch;
-(void) setCameraPosition:(ELCameraType)camera;
-(void) setMinFrameDuration:(NSInteger)duration;

-(BOOL) startCamera;
-(BOOL) stopCamera;

-(UIImage *) getCurrentImage;
-(void) captureOutput:(AVCaptureOutput *)captureOutput
        didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection;

@end

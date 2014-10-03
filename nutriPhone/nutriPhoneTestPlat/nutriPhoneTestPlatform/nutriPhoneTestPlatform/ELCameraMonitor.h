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

@interface ELCameraMonitor : UIView <AVCaptureVideoDataOutputSampleBufferDelegate> {
    NSData *imageData;
    UIImage *image;
    NSMutableArray *sampleImageBuffer;
    CGRect previewRect;
    UInt64 totalTime;
    UInt64 intervalTime;

    int nextImagePointer;
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
@property (nonatomic, strong) UITableView *satTable;
@property (nonatomic, assign) BOOL draggablePreview;
@property (nonatomic, assign) BOOL videoStopped;
@property (nonatomic, assign) UInt64 timeLastImageCaptured;
@property (nonatomic, assign) UInt64 timeStart;

-(id) initWithPreview;
-(id) initWithoutPreview;
-(void) setToDefaults;
-(void) setTorch:(BOOL)torch;
-(void) setPreviewRect: (CGRect)rect;
-(void) backCameraOn:(BOOL)backCamera;
-(void) setTotalTime: (NSInteger) total withInterval :(NSInteger) interval;
-(BOOL) startCamera;

-(NSData *) getLastImageData;
-(NSData *) getNextImageData;
-(NSData *) addImageToBuffer:(NSData*) imageDataToAdd;
-(void) captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection;

@end

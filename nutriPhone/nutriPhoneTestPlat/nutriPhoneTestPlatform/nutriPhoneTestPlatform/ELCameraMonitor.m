//
//  ELCameraMonitor.m
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/3/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ELCameraMonitor.h"

@implementation ELCameraMonitor

@synthesize cameraType, session, videoConnection, videoDataOutput, captureDevice;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setToDefaults];
    }
    return self;
}

- (id) initWithPreview
{
    if (!previewRectDefined)
        previewRect = CGRectMake(180, 30, 120, 90);
    return [self initWithFrame:previewRect];
}

- (id) initWithoutPreview
{
    if (!previewRectDefined)
        previewRect = CGRectMake(0, 0, 0, 0);
    return [self initWithFrame:previewRect];
}

- (void) setToDefaults
{
    visiblePreview = YES;
    torchOn = YES;
    [self setBackgroundColor:[UIColor blackColor]];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.cameraType = AVCaptureDevicePositionBack;
}

- (void) setTorch:(BOOL)torch
{
    torchOn = torch;
}

- (void) setPreviewRect:(CGRect)rect
{
    previewRectDefined = YES;
    previewRect = rect;
}

- (void) backCameraOn:(BOOL)backCamera
{
    if (backCamera)
        cameraType = AVCaptureDevicePositionBack;
    else cameraType = AVCaptureDevicePositionFront;
}

- (void) setTotalTime:(NSInteger)total withInterval:(NSInteger)interval
{
    totalTime = total;
    intervalTime = interval;
}

- (void)startCamera
{
    AVCaptureDevice *device = [self CameraIfAvailable];
    
    if (device) {
        if (!session) {
            session = [[AVCaptureSession alloc] init];
        }
        session.sessionPreset = AVCaptureSessionPresetLow;
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Cannot open camera"  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            NSLog(@"ERROR: trying to open camera:%@", error);
        } else {
            if ([session canAddInput:input]) {
                //Everythings working, start running camera
                [session addInput:input];
                if (visiblePreview) {
                    //Show preview of graph
                    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
                    
                    captureVideoPreviewLayer.frame = self.bounds;
                    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    
                    [self.layer addSublayer:captureVideoPreviewLayer];
                }
                [session startRunning];
                self.videoStopped = NO;
                //Set up image output;
                //videoDataOutput code
                videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
                videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey: (id)kCVPixelBufferPixelFormatTypeKey];
                
                [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
                dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
                [videoDataOutput setSampleBufferDelegate:self queue:queue];
                //dispatch_release(queue);
                
                
                AVCaptureConnection *connection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
                [connection setVideoMaxFrameDuration:CMTimeMake(1, 20)];
                [connection setVideoMinFrameDuration:CMTimeMake(1, 10)];
                
                [[self session] addOutput:videoDataOutput];
                //Turn on flash light
                if ([captureDevice hasTorch] && [captureDevice hasFlash] && torchOn) {
                    if (captureDevice.torchMode == AVCaptureTorchModeOff)  {
                        [session beginConfiguration];
                        [captureDevice lockForConfiguration:nil];
                        [captureDevice setTorchMode:AVCaptureTorchModeOn];
                        [captureDevice setFlashMode:AVCaptureFlashModeOn];
                        [captureDevice unlockForConfiguration];
                        [session commitConfiguration];
                    }
                }
                
                self.timeStart = [[NSDate date] timeIntervalSince1970]*1000;
                self.timeLastImageCaptured = self.timeStart;
                
                
                //Find correct AVCaputureConnection in AVCaptureStillImageOutput
                //StillImageOutput code
                /*
                 for (AVCaptureConnection *connection in stillImageOutput.connections) {
                 for (AVCaptureInputPort *port in [connection inputPorts]) {
                 if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                 videoConnection = connection;
                 break;
                 }
                 }
                 }*/
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Couldn't add input"  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
                NSLog(@"ERROR: Couldn't add input");
            }
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Camera not available"  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        NSLog(@"ERROR: Camera not available");
    }
    
}

- (AVCaptureDevice *)CameraIfAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == self.cameraType) {
            captureDevice = device;
            break;
        }
    }
    
    //If no capture device found
    if (!captureDevice) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

@end



















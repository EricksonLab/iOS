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
//Initial preview at CGRect frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setToDefaults];
    }
    return self;
}

- (id) initWithPreview
//Initial preview at set position
{
    if (!previewRectDefined)
        previewRect = CGRectMake(180, 30, 120, 90);
    return [self initWithFrame:previewRect];
}

- (id) initWithoutPreview
//Initial camera without preview
{
    if (!previewRectDefined)
        previewRect = CGRectMake(0, 0, 0, 0);
    return [self initWithFrame:previewRect];
}

- (void) setToDefaults
//set all value to defaults
{
    minFrameDuration = 200;
    visiblePreview = YES;
    torchOn = YES;
    [self setBackgroundColor:[UIColor blackColor]];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.cameraType = AVCaptureDevicePositionBack;
}

- (void) setTorch:(BOOL)torch
//set torch status
{
    torchOn = torch;
}

- (void) setPreviewRect:(CGRect)rect
//set preview position. MUST BE CALLED BEFORE initWithPreview()
{
    previewRectDefined = YES;
    previewRect = rect;
}

-(void) setCameraPosition:(ELCameraType)camera
//set camera used
{
    if (camera == BACK)
        cameraType = AVCaptureDevicePositionBack;
    else cameraType = AVCaptureDevicePositionFront;
}

-(void) setMinFrameDuration:(NSInteger)interval
//set min time between frames to save system resource
{
    minFrameDuration = interval;
}

- (BOOL)startCamera
//start camera and record current frame as UIImage
{
    AVCaptureDevice *device = [self CameraIfAvailable];
    
    if (device)
    {
        if (!session)
        {
            session = [[AVCaptureSession alloc] init];
        }
        session.sessionPreset = AVCaptureSessionPresetLow;
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Cannot open camera"  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            NSLog(@"ERROR: trying to open camera:%@", error);
            return NO;
        } else {
            if ([session canAddInput:input])
            {
                //Everythings working, start running camera
                [session addInput:input];
                if (visiblePreview)
                {
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
                
                
                [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
                
                [[self session] addOutput:videoDataOutput];
                //Turn on flash light
                if ([captureDevice hasTorch] && [captureDevice hasFlash] && torchOn)
                {
                    if (captureDevice.torchMode == AVCaptureTorchModeOff)
                    {
                        [session beginConfiguration];
                        [captureDevice lockForConfiguration:nil];
                        [captureDevice setTorchMode:AVCaptureTorchModeOn];
                        [captureDevice setFlashMode:AVCaptureFlashModeOn];
                        [captureDevice unlockForConfiguration];
                        [session commitConfiguration];
                    }
                }
                
                timeLastFrame = [[NSDate date] timeIntervalSince1970]*1000;
                NSLog(@"Video capture start");
                return YES;
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Couldn't add input"  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
                NSLog(@"ERROR: Couldn't add input");
                return NO;
            }
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Camera not available"  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        NSLog(@"ERROR: Camera not available");
        return NO;
    }
}

- (AVCaptureDevice *)CameraIfAvailable
//test if camera is availabe
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

-(void) captureOutput:(AVCaptureOutput *)captureOutput
        didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection
//if delegate activated, save image
{
    timeCurrentFrame = [[NSDate date] timeIntervalSince1970]*1000;
    if (timeCurrentFrame - timeLastFrame >= minFrameDuration)
        timeLastFrame = timeCurrentFrame;
    else return;
    UIImage* imageTemp = [self imageFromSampleBuffer:sampleBuffer];
    imageData = UIImageJPEGRepresentation(imageTemp, 1.0);
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
//converte sample buffer to UIImage
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    // Creat a array with hsv color data
        // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    // Create and return an image object representing the specified Quartz image
    UIImage * currentImage = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationRight];
    CGImageRelease(cgImage);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return currentImage;
}

-(UIImage *) getCurrentImage
{
    NSLog(@"Rendering current Image");
    if (!imageData) NSLog(@"No imagedata in ELCM");
    image = [UIImage imageWithData:imageData];
    return image;
}

-(BOOL) stopCamera
{
//Stop camera session
    if(session)
    {
        if (captureDevice.torchMode == AVCaptureTorchModeOn)
        {
            [session beginConfiguration];
            [captureDevice lockForConfiguration:nil];
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
            [captureDevice setFlashMode:AVCaptureFlashModeOff];
            [captureDevice unlockForConfiguration];
            [session commitConfiguration];
        }
        [session stopRunning];
        session= nil;
        self.videoStopped = YES;
        NSLog(@"Video capture stop");
        return YES;
    }
    return NO;
}

/*********************Private Methods**********************/



@end



















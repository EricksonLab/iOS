//
//  ELCameraMonitor.m
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/3/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ELCameraMonitor.h"

#define ELCameraMonitorTorchOn YES;

typedef struct {
    int hue;
    float sat,lig;
    BOOL valid;
}HSLPixel;

@implementation ELCameraMonitor

@synthesize cameraType, session, videoConnection, videoDataOutput, captureDevice;

static ELCameraMonitor* sharedMonitor;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Initialization

- (id) init
{
    return [self initWithDefaltSettings];
}


- (id) initWithDefaltSettings
{
    @synchronized (self) {
        self = [super init];
        if (self) {
            // Initialization code
            [self setToDefaults];
        }
        return self;
    }
}

-(id) initWithCamera:(ELCameraType)camera
      torchMode:(ELCameraMonitorTorchMode)torchMode
      minFrameDuration:(NSInteger)duration
{
    self = [super init];
    if (self) {
        // Initialization code
        [self setCameraPosition:BACK];
        [self setTorchStatus:ELCameraMonitorTorchModeOn];
        [self setMinFrameDuration:duration];
    }
    return self;
}

#pragma mark - Color calibration

int maxValue(int r, int g, int b){
    int max = r;
    if (g>max) max = g;
    if (b>max) max = b;
    return max;
}

int minValue(int r, int g, int b){
    int min = r;
    if (g<min) min = g;
    if (b<min) min = b;
    return min;
}

int hueFromRGB(int r, int g, int b){
    int max = maxValue(r, g, b);
    int min = minValue(r, g, b);
    float dif = max - min;
    if (dif==0) return 0;
    else if (max == r && g>=b) return (int)roundf(60*(g-b)/dif);
    else if (max == r && g<b) return (int)roundf(60*(g-b)/dif+360);
    else if (max == g) return (int)roundf(60*(b-r)/dif+120);
    else return (int)roundf(60*(r-g)/dif+240);
}

float satFromRGB(int r, int g, int b){
    float l = ligFromRGB(r,g,b);
    float max = maxValue(r, g, b);
    float min = minValue(r, g, b);
    float dif = (float)(max - min)/2.55;
    if (l<0.5) return dif/l/2;
    else return dif/(2-2*l);
}

float ligFromRGB(int r, int g, int b){
    return 0.5*(maxValue(r, g, b) + minValue(r, g, b))/255;
}


#pragma mark - Setting Functions

- (void) setToDefaults
//set all value to defaults
{
    minFrameDuration = 200;
    torchMode = YES;
    self.cameraType = AVCaptureDevicePositionBack;
}

- (void) setTorchMode:(ELCameraMonitorTorchMode)torch
//set torch status
{
    torchMode = torch;
}

-(void) setCameraPosition:(ELCameraType)camera
//set camera used
{
    if (camera == BACK)
        cameraType = AVCaptureDevicePositionBack;
    else cameraType = AVCaptureDevicePositionFront;
}

-(void) setMinFrameDuration:(NSInteger)duration
//set min time between frames to save system resource
{
    if (duration<100) duration = 100;
    minFrameDuration = duration;
}

#pragma mark - Camera Control

- (BOOL)startCamera
//start camera and record current frame as UIImage
{
    if (session) return YES;
    AVCaptureDevice *device = [self cameraIfAvailable];
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
            session = nil;
            return NO;
        } else {
            if ([session canAddInput:input])
            {
                //Everythings working, start running camera
                [session addInput:input];
                [session startRunning];
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
                
                
                timeLastFrame = [[NSDate date] timeIntervalSince1970]*1000;
                NSLog(@"Video capture start");
                return YES;
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Couldn't add input"  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
                NSLog(@"ERROR: Couldn't add input");
                session = nil;
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

- (AVCaptureDevice *)cameraIfAvailable
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
    UInt8 *pointer = (UInt8 *)baseAddress;
    int size = (int)(bufferSize - 8)/4; //Each 4 bytes represents a pixel, except last 8 bytes
//    UInt8 imageByteData[height][width][4];
    HSLPixel pixels[size];
    float pixelCount[1000] = {0};
    for (int i = 0; i<size; i++) {
        int b = *pointer; pointer++;
        int g = *pointer; pointer++;
        int r = *pointer; pointer=pointer+2; //Skip alpha value
        pixels[i].hue = hueFromRGB(r,g,b);
        pixels[i].lig = ligFromRGB(r,g,b);
        pixels[i].sat = satFromRGB(r,g,b);
        if((float)(i / width)>0.25*height && (float)(i / width)<0.75*height)
            pixelCount[i % width] = pixelCount[i % width] + (float)hueFromRGB(r, g, b) *2 / width;
    }
    
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
        NSLog(@"Video capture stop");
        return YES;
    }
    return NO;
}

-(void) restoreSettings {
    
    if ([captureDevice hasTorch] && [captureDevice hasFlash]) {
        if (captureDevice.torchMode == AVCaptureTorchModeOff && torchMode==ELCameraMonitorTorchModeOn) {
            [session beginConfiguration];
            [captureDevice lockForConfiguration:nil];
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
            [captureDevice setFlashMode:AVCaptureFlashModeOn];
            [captureDevice unlockForConfiguration];
            [session commitConfiguration];
        } else if (captureDevice.torchMode == AVCaptureTorchModeOn && torchMode==ELCameraMonitorTorchModeOff){
            [session beginConfiguration];
            [captureDevice lockForConfiguration:nil];
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
            [captureDevice setFlashMode:AVCaptureFlashModeOff];
            [captureDevice unlockForConfiguration];
            [session commitConfiguration];
        }
    }
}

#pragma mark - Output

-(UIImage *) getCurrentImage
{
    NSLog(@"Rendering current Image");
    if (!imageData) NSLog(@"No imagedata in ELCM");
    image = [UIImage imageWithData:imageData];
    return image;
}


/*********************Private Methods**********************/



@end



















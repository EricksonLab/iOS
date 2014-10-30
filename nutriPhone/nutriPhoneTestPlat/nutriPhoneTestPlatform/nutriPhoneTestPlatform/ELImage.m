//
//  ELImage.m
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-30.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import "ELImage.h"

@implementation ELImage

@synthesize width,height,imageBuffer;
#pragma mark - Public variables

-(id)initWithCVImageBufferRef:(CVImageBufferRef)imageBufferRef{
    self = [super init];
    if (self) {
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBufferRef,0);
        // Get the number of bytes per row for the pixel buffer
        // Get the pixel buffer width and height
        width = CVPixelBufferGetWidth(imageBufferRef);
        height = CVPixelBufferGetHeight(imageBufferRef);
        // Create a device-dependent RGB color space
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        if (!colorSpace)
        {
            NSLog(@"CGColorSpaceCreateDeviceRGB failure");
            return nil;
        }
        // Get the base address of the pixel buffer
        void *baseAddress = CVPixelBufferGetBaseAddress(imageBufferRef);
        UInt8* pointer = (UInt8*)baseAddress;
        imageBuffer=(ELColor *)malloc(sizeof(ELColor)*width*height);
        for (int i=0;i<width*height;i++) {
            imageBuffer[i].r = *pointer;
            pointer++;
            imageBuffer[i].g = *pointer;
            pointer++;
            imageBuffer[i].b = *pointer;
            pointer++;
            imageBuffer[i].a = *pointer;
            pointer++;
        }
    }
    return self;
}

-(id)initWithELImage:(ELImage*)sourceImage{
    self = [super init];
    if (self) {
        width = sourceImage.width;
        height = sourceImage.height;
        imageBuffer=(ELColor *)malloc(sizeof(ELColor)*width*height);
        for (int i=0;i<width*height;i++) {
            imageBuffer[i] = sourceImage.imageBuffer[i];
        }
    }
    return self;
}

-(id)initWithWidth:(size_t)imgWidth Height:(size_t)imgHeight{
    self = [super init];
    if (self) {
        width = imgWidth;
        height = imgHeight;
        imageBuffer=(ELColor *)malloc(sizeof(ELColor)*width*height);
        for (int i=0;i<width*height;i++) {
            imageBuffer[i].r = 0;
            imageBuffer[i].g = 0;
            imageBuffer[i].b = 0;
            imageBuffer[i].a = 255;
        }
    }
    return self;
}

-(id)initWithELColorBufferRef:(ELColor*)colorBufferRef Width:(size_t)imgWidth Height:(size_t)imgHeight{
    colorBufferRef[9999] = colorBufferRef[0];
    
    self = [super init];
    if (self) {
        width = imgWidth;
        height = imgHeight;
        imageBuffer=(ELColor *)malloc(sizeof(ELColor)*width*height);
        for (int i=0;i<width*height;i++) {
            imageBuffer[i] = colorBufferRef[i];
        }
    }
    return self;
}
#pragma mark - Pixel operation


-(ELColor) colorAtX:(uint)x Y:(uint)y{
    uint n = x-1 + (y-1)*width;
    ELColor color = imageBuffer[n];
    return color;
}

-(void) setColorAtX:(uint)x Y:(uint)y Color:(ELColor)color{
    uint n = x-1 + (y-1)*width;
    imageBuffer[n] = color;
}

@end

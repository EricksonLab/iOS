//
//  ELImage.h
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-30.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

typedef struct{
    int r;
    int g;
    int b;
    int a;
}ELColor;

typedef enum{
    ELImageTypeRGB = 0,
    ELImageTypeHSV = 1,
    ELImageTypeHSL = 2,
    ELImageTypeGrayScale = 3,
}ELImageType;

@interface ELImage: NSObject {
}


@property (assign, nonatomic) size_t width;
@property (assign, nonatomic) size_t height;
@property (assign, nonatomic) ELColor* imageBuffer;



-(id)initWithCVImageBufferRef:(CVImageBufferRef)imageBufferRef;
-(id)initWithELImage:(ELImage*)sourceImage;
-(id)initWithELColorBufferRef:(ELColor*)colorBufferRef Width:(size_t)imgWidth Height:(size_t)imgHeight;
-(id)initWithWidth:(size_t)imgWidth Height:(size_t)imgHeight;


-(ELColor) colorAtX:(uint)x Y:(uint)y;
-(void) setColorAtX:(uint)x Y:(uint)y Color:(ELColor)color;


@end

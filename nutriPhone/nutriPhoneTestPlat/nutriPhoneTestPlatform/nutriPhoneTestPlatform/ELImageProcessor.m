//
//  ELImageProcessor.m
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/30/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ELImageProcessor.h"

@implementation ELImageProcessor

#pragma mark - Type definition

typedef struct {
    int hue;
    float sat,lig;
    BOOL valid;
}HSLpixel;

#pragma mark - Color operation

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

#pragma mark - Image transform
+(ELImage*)clipELImage:(ELImage*)sourceImage
                 AtTop:(uint)top Left:(uint)left
                 Bottom:(uint)bottom Rightt:(uint)right{
    if (top<=0 || top>sourceImage.height || left<=0 || left>sourceImage.width || bottom<=0 || bottom>sourceImage.height || right<=0 || right>sourceImage.width || left>right || bottom<top) {
        NSLog(@"Error clipping image: input arguments error");
        return nil;
    }
    size_t newWidth = right-left+1;
    size_t newHeight = bottom-top+1;
    ELImage* newImage = [[ELImage alloc] initWithWidth:newWidth Height:newHeight];
    uint newImagePointer = 0;
    for (int i=top; i<=bottom; i++)
        for (int j=left; j<right; j++) {
            uint n = j-1 + (i-1)*newWidth;
            newImage.imageBuffer[newImagePointer]=sourceImage.imageBuffer[n];
        }
    return newImage;
}

#pragma mark - Accumulates




#pragma mark - Mophology 1D



#pragma mark - Mophology 2D



@end

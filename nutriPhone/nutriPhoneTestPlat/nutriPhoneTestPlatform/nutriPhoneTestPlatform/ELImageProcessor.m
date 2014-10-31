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

float hueFromRGB(int r, int g, int b){
    int max = maxValue(r, g, b);
    int min = minValue(r, g, b);
    float dif = max - min;
    if (dif==0) return 0;
    else if (max == r && g>=b) return 60.0*(g-b)/dif;
    else if (max == r && g<b) return 60.0*(g-b)/dif+360;
    else if (max == g) return 60*(b-r)/dif+120;
    else return 60*(r-g)/dif+240;
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
    //    NSLog(@"left:%d right:%d top:%d bottom:%d AND width:%zu height:%zu",left,right,top,bottom,sourceImage.width,sourceImage.height);
        return nil;
    }
    size_t newWidth = right-left+1;
    size_t newHeight = bottom-top+1;
    ELImage* newImage = [[ELImage alloc] initWithWidth:newWidth Height:newHeight];
    for (int i=top; i<=bottom; i++)
        for (int j=left; j<right; j++) {
            ELColor color = [sourceImage colorAtX:j Y:i];
            [newImage setColorAtX:j-left+1 Y:i-top+1 Color:color];
        }
    return newImage;
}

#pragma mark - Accumulates

+(NSArray*)sumUpHueAlongAxisYFrom:(ELImage*)sourceImage Bias:(int)bias{
    float accHue;
    NSMutableArray* tempArray = [NSMutableArray array];
    for (int i = 1; i<=sourceImage.width; i++){
        accHue = 0;
        for (int j = 1; j<sourceImage.height; j++)
        {
            ELColor color = [sourceImage colorAtX:i Y:j];
            float hue = hueFromRGB(color.r, color.g, color.b)+bias;
            if (hue<0)
                hue = hue + 360;
            else if (hue>360)
                hue = hue - 360;
            accHue = accHue + hue;
        }
        [tempArray addObject:[NSNumber numberWithFloat:accHue]];
    }
    return tempArray;
}



#pragma mark - Mophology 1D



#pragma mark - Mophology 2D



@end

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

+(NSArray*) getPregResultTrend:(ELImage*)sourceImage{
    ELImage* effectiveImage = [ELImageProcessor clipELImage:sourceImage AtTop:51 Left:1 Bottom:94 Rightt:192];
    NSArray* sumUpData = [NSArray arrayWithArray:[ELImageProcessor sumUpHueAlongAxisYFrom:effectiveImage Bias:-100]];
    NSArray* backgroundData = [NSArray arrayWithArray:[ELImageProcessor morphologyOpen1D:sumUpData StructureElementSize:30]];
    NSArray* dataToPlot = [NSArray arrayWithArray:[ELImageProcessor extractBackgroundData:backgroundData FromSourceData:sumUpData]];
    return dataToPlot;
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
        for (int j=left; j<=right; j++) {
            ELColor color = [sourceImage colorAtX:j Y:i];
            [newImage setColorAtX:j-left+1 Y:i-top+1 Color:color];
        }
    return newImage;
}




#pragma mark - Data process

+(NSArray*)sumUpHueAlongAxisYFrom:(ELImage*)sourceImage Bias:(int)bias{
    float accHue;
    NSMutableArray* sourceData = [NSMutableArray array];
    for (int i = 1; i<=sourceImage.width; i++){
        accHue = 0;
        for (int j = 1; j<=sourceImage.height; j++)
        {
            ELColor color = [sourceImage colorAtX:i Y:j];
            float hue = hueFromRGB(color.r, color.g, color.b)+bias;
            if (hue<0)
                hue = hue + 360;
            else if (hue>360)
                hue = hue - 360;
            accHue = accHue + hue;
        }
        [sourceData addObject:[NSNumber numberWithFloat:accHue]];
    }
 //   NSLog(@"In sum up, last value %@",[sourceData lastObject]);
    return sourceData;
}

+(NSArray*)hueStatisticFrom:(ELImage*)sourceImage Bias:(int)bias{
    int countOfPixels[360] = {0};
    NSMutableArray* hueStat = [NSMutableArray arrayWithCapacity:360];
    for (int i = 1; i<=sourceImage.width; i++){
        for (int j = 1; j<=sourceImage.height; j++)
        {
            ELColor color = [sourceImage colorAtX:i Y:j];
            int hue = (int)floor(hueFromRGB(color.r, color.g, color.b)+bias);
            if (hue<0)
                hue = hue + 360;
            else if (hue>=360)
                hue = hue - 360;
            countOfPixels[hue]++;
        }
    }
    for (int i = 0; i<360; i++)
        [hueStat addObject:[NSNumber numberWithInt:countOfPixels[i]]];
    return hueStat;
}

+(ELTestResult) getPregResultFromData:(NSArray*)sourceData {
    NSRange firstHalf;
    firstHalf.location = 0;
    firstHalf.length = [sourceData count]/2;
    NSRange secondHalf;
    secondHalf.location = [sourceData count]/2+1;
    secondHalf.length = [sourceData count] - secondHalf.location;
    NSArray* firstHalfData = [sourceData subarrayWithRange:firstHalf];
    NSArray* secondHalfData = [sourceData subarrayWithRange:secondHalf];
    NSNumber* firstHalfPeakIntegral = [self integralPeakIn:firstHalfData];
    NSNumber* secondHalfPeakIntergral = [self integralPeakIn:secondHalfData];
    if (firstHalfPeakIntegral.floatValue == 0.0 || firstHalfPeakIntegral.floatValue < secondHalfPeakIntergral.floatValue)
        return ELTestResultUncertain;
    else if (firstHalfPeakIntegral.floatValue > secondHalfPeakIntergral.floatValue * 1.5 )
        return ELTestResultNegative;
    else return ELTestResultPositive;
}

+(NSNumber*) getCholResult:(ELImage*)sourceImage{
//    if (sourceImage) NSLog(@"has image");
    NSArray* hueStat = [NSArray arrayWithArray:[self hueStatisticFrom:sourceImage Bias:0]];
    NSRange range;
    range.location =120;
    range.length = 120;
    NSArray* hueStatEffective = [hueStat subarrayWithRange:range];
    NSNumber* mean = [self meanOf:hueStatEffective];
    NSNumber* stadev = [self standardDeviationOf:hueStatEffective];
    float accSat = 0;
    int numOfEffectivePoints = 0;
    for (int i = 1; i<=sourceImage.width; i++){
        for (int j = 1; j<=sourceImage.height; j++)
        {
            ELColor color = [sourceImage colorAtX:i Y:j];
            float hue = hueFromRGB(color.r, color.g, color.b);
            if (hue-range.location < mean.floatValue + 2*stadev.floatValue && hue - range.location > mean.floatValue - 2*stadev.floatValue) {
                float sat = satFromRGB(color.r, color.g, color.b);
                accSat +=sat;
                numOfEffectivePoints++;
            }
        }
    }
//    NSLog(@"accSat %f, numOfEffectPoints %d",accSat,numOfEffectivePoints);
//    NSLog(@"mean %f, stdev %f",mean.floatValue,stadev.floatValue);
    if (numOfEffectivePoints == 0) return [NSNumber numberWithFloat:-1.0];
    float S = accSat/numOfEffectivePoints;
    float finalResult = 0.08*S*S - 4.56*S + 196.84;
    return [NSNumber numberWithFloat:finalResult];
}



#pragma mark - Mophology 1D

+(NSArray*)morphologyErosion1D:(NSArray*)sourceData StructureElementSize:(int)size{
    if (size<=0 || size>=[sourceData count]) {
        NSLog(@"Structure size error");
        return sourceData;
    }
    NSMutableArray* newData = [NSMutableArray arrayWithArray:sourceData];
    for (int i = 0; i<[sourceData count]; i++){
        int elementStart = i - size/2;
        if (elementStart < 0) elementStart = 0;
        if (elementStart + size >=[sourceData count]) size = [sourceData count]-elementStart-1;
        NSRange elementRange;
        elementRange.location = elementStart;
        elementRange.length = size;
        float minValue = [self minValueInArray:[sourceData subarrayWithRange:elementRange]];
        NSNumber* newValue = [NSNumber numberWithFloat:minValue];
        [newData replaceObjectAtIndex:i withObject:newValue];
    }
    return newData;
}


+(NSArray*)morphologyDilation1D:(NSArray*)sourceData StructureElementSize:(int)size{
    if (size<=0 || size>=[sourceData count]) {
        NSLog(@"Structure size error");
        return sourceData;
    }
    NSMutableArray* newData = [NSMutableArray arrayWithArray:sourceData];
    for (int i = 0; i<[sourceData count]; i++){
        int elementStart = i - size/2;
        if (elementStart < 0) elementStart = 0;
        if (elementStart + size >=[sourceData count]) size = [sourceData count]-elementStart-1;
        NSRange elementRange;
        elementRange.location = elementStart;
        elementRange.length = size;
        float maxValue = [self maxValueInArray:[sourceData subarrayWithRange:elementRange]];
        NSNumber* newValue = [NSNumber numberWithFloat:maxValue];
        [newData replaceObjectAtIndex:i withObject:newValue];
    }
    return newData;
}

+(NSArray*)morphologyOpen1D:(NSArray*)sourceData StructureElementSize:(int)size{
    return [self morphologyDilation1D:[self morphologyErosion1D:sourceData StructureElementSize:size] StructureElementSize:size];
}

+(NSArray*)morphologyClose1D:(NSArray*)sourceData StructureElementSize:(int)size{
    return [self morphologyErosion1D:[self morphologyDilation1D:sourceData StructureElementSize:size] StructureElementSize:size];
}

#pragma mark - Mophology 2D


#pragma mark - data manipulation

+(float) maxValueInArray:(NSArray*)array {
    NSNumber* val = [array objectAtIndex:0];
    float max = val.floatValue;
    for (int i = 1; i<[array count];i++) {
        val = [array objectAtIndex:i];
        if (max<val.floatValue) max = val.floatValue;
    }
    return max;
}


+(float) minValueInArray:(NSArray*)array {
    NSNumber* val = [array objectAtIndex:0];
    float min = val.floatValue;
    for (int i = 1; i<[array count];i++) {
        val = [array objectAtIndex:i];
        if (min>val.floatValue) min = val.floatValue;
    }
    return min;
}

+(int) indexOfMaxValueInArray:(NSArray*)array {
    NSNumber* val = [array objectAtIndex:0];
    float max = val.floatValue;
    int index = 0;
    for (int i = 1; i<[array count];i++) {
        val = [array objectAtIndex:i];
        if (max<val.floatValue) {
            max = val.floatValue;
            index = i;
        }
    }
    return index;
}


+(int) indexOfMinValueInArray:(NSArray*)array {
    NSNumber* val = [array objectAtIndex:0];
    float min = val.floatValue;
    int index = 0;
    for (int i = 1; i<[array count];i++) {
        val = [array objectAtIndex:i];
        if (min<val.floatValue) {
            min = val.floatValue;
            index = i;
        }    }
    return index;
}

+(NSArray*) extractBackgroundData:(NSArray*)backgroundData FromSourceData:(NSArray*)sourceData {
    if ([backgroundData count]!=[sourceData count]) {
        NSLog(@"Background %d/source %d data not compatible",[backgroundData count],[sourceData count]);
        return sourceData;
    }
    if ([sourceData count]==0){
        NSLog(@"Source data empty");
        return sourceData;
    }
    NSMutableArray* newData = [NSMutableArray arrayWithCapacity:[sourceData count]];
    for (int i=0;i<[sourceData count];i++) {
        NSNumber* sourceValue = [sourceData objectAtIndex:i];
    //    NSLog(@"Source value %f",sourceValue.floatValue);
        NSNumber* backgroundValue = [backgroundData objectAtIndex:i];
    //    NSLog(@"Background value %f",backgroundValue.floatValue);
        NSNumber* newValue = [NSNumber numberWithFloat:sourceValue.floatValue-backgroundValue.floatValue];
        [newData addObject:newValue];
    }
    return newData;
}

+(NSNumber*) integralPeakIn:(NSArray*)array {
    float mean = [[self meanOf:array] floatValue];
    int peakMaxIndex = [self indexOfMaxValueInArray:array];
    if ([[array objectAtIndex:peakMaxIndex] floatValue]<mean+[[self standardDeviationOf:array] floatValue]*2) {
        NSLog(@"Found no peak in array");
        return [NSNumber numberWithFloat:0.0];
    }
    float integral = [[array objectAtIndex:peakMaxIndex] floatValue];
    for (int i = peakMaxIndex+1;i<[array count];i++) {
        float value = [[array objectAtIndex:i] floatValue];
        if (value>mean )
            integral += value;
    }
    for (int i = peakMaxIndex-1;i>=0;i--) {
        float value = [[array objectAtIndex:i] floatValue];
        if (value>mean)
            integral += value;
    }
    return [NSNumber numberWithFloat:integral];
}

+(NSNumber *)meanOf:(NSArray *)array
{
    float runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number floatValue];
    }
    
    return [NSNumber numberWithFloat:(runningTotal / [array count])];
}

+(NSNumber *)standardDeviationOf:(NSArray *)array
{
    if(![array count]) return nil;
    
    float mean = [[self meanOf:array] floatValue];
    float sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array)
    {
        float valueOfNumber = [number floatValue];
        float difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return [NSNumber numberWithFloat:sqrt(sumOfSquaredDifferences / [array count])];
}

@end

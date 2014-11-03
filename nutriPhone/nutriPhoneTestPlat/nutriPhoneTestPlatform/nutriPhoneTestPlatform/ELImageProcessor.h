//
//  ELImageProcessor.h
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/30/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELImage.h"

typedef enum{
    ELTestResultPositive = 1,
    ELTestResultNegative = 0,
    ELTestResultUncertain = 3,
}ELTestResult;

@interface ELImageProcessor : NSObject

+(ELImage*)clipELImage:(ELImage*)sourceImage
                 AtTop:(uint)top Left:(uint)left
                Bottom:(uint)bottom Rightt:(uint)right;

+(NSArray*)sumUpHueAlongAxisYFrom:(ELImage*)sourceImage Bias:(int)bias;
+(NSArray*)morphologyErosion1D:(NSArray*)sourceData StructureElementSize:(int)size;
+(NSArray*)morphologyDilation1D:(NSArray*)sourceData StructureElementSize:(int)size;
+(NSArray*)morphologyOpen1D:(NSArray*)sourceData StructureElementSize:(int)size;
+(NSArray*)morphologyClose1D:(NSArray*)sourceData StructureElementSize:(int)size;
+(NSArray*) getPregResultTrend:(ELImage*)sourceImage;
+(ELTestResult) getPregResultFromData:(NSArray*)sourceData;
+(NSNumber *)meanOf:(NSArray *)array;
+(NSNumber *)standardDeviationOf:(NSArray *)array;
@end

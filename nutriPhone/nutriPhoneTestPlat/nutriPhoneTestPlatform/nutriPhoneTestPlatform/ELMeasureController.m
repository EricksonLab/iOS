//
//  ELMeasureController.m
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-8.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import "ELMeasureController.h"

@implementation ELMeasureTimer

//Currently all measurement timer funtion are in ViewController, but we can play with delegate when doing time related test

#pragma mark - Initialization

-(id) init{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;
    
}

-(void) initWithSettings {
    
}

-(void) initWithTimePoints {
    
}

#pragma mark - Settings

-(void) setIdleTime{
    
}
-(void) setTotalMeasureTimeLength{
    
}
-(void) setIntervalTimeBetweenMeasures{
    
}
-(void) setNextMeasureTime{
    
}
-(void) setMeasureTimePoints{
    
}

#pragma mark - Measurement Control
-(void) torchOn {
    
}
-(void) torchOff {
    
}
-(void) start{
    
}
-(void) stop {
    
}

#pragma mark - Sample Control
-(void) addSampleImageToBuffer {
    
}

-(void) getNextSampleImage {
    
}

-(void) getLastSampleImage {
    
}
-(void) getSampleImageBuffer{
    
}
@end

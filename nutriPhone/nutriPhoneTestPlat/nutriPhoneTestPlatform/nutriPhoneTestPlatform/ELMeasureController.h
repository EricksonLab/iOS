//
//  ELMeasureController.h
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-8.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ELMeasureTimerDelegate <NSObject>

@optional

-(void) didReceiveTakeMeasurementRequest:(NSDate *)date;
-(void) didReceiveEndMeasurementRequest:(NSDate *)date;

@end

@interface ELMeasureTimer : NSObject
//Currently all measurement timer funtion are in ViewController, but we can play with delegate when doing time related test

@property (nonatomic, unsafe_unretained) id <ELMeasureTimerDelegate> delegate;

@property (strong, nonatomic) NSTimer *measureTimer;
@property (assign, nonatomic) float totalTestLength;
@property (assign, nonatomic) float intervalBetweenMeasurements;

@end

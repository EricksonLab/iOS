//
//  stepCalculator.h
//  test
//
//  Created by NutriPhone on 11/10/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STEP_COUNT_CHANGED_NOTIFICATION @"Step count changed"

@protocol stepCalculatorDelegate <NSObject>

@optional

-(void) receiveStep:(NSString *)step;
-(void) receiveLocation:(NSString *)location;

@end


@interface stepCalculator : NSObject {
    NSObject* delegateObject;
}

@property (assign,nonatomic) id<stepCalculatorDelegate> delegate;

-(void)run;

@end

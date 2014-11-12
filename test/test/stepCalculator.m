//
//  stepCalculator.m
//  test
//
//  Created by NutriPhone on 11/10/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "stepCalculator.h"

@implementation stepCalculator

-(void)run {
    
    NSNumber* step = [NSNumber numberWithInt:3];
    [[NSNotificationCenter defaultCenter] postNotificationName:STEP_COUNT_CHANGED_NOTIFICATION object:nil userInfo:@{@"Step Counts":step}];
}

@end

//
//  ViewControllerStep.h
//  test
//
//  Created by NutriPhone on 11/9/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stepCalculator.h"

@interface ViewControllerStep : UIViewController

@property (nonatomic,strong) stepCalculator* cal;



- (IBAction)clickStep:(id)sender;

@end

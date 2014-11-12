//
//  ViewController.h
//  test
//
//  Created by NutriPhone on 11/9/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol onReceiveDataDelegate

-(void) receiveStep:(NSString *)step;
-(void) receiveLocation:(NSString *)location;

@end

@interface ViewController : UIViewController

@property (assign,nonatomic) id<onReceiveDataDelegate> delegate;


@end


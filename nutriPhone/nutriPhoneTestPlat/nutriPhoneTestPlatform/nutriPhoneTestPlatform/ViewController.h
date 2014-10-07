//
//  ViewController.h
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/2/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCameraMonitor.h"
#import "ELTestVideoPreview.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) ELTestVideoPreview* testVideoPreview;
@property (strong, nonatomic) ELCameraMonitor* cameraMonitor;



- (IBAction)showImage:(UIButton *)sender;
- (IBAction)start:(UIButton *)sender;
- (IBAction)stop:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;

@end


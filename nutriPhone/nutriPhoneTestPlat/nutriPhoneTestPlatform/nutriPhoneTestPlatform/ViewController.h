//
//  ViewController.h
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/2/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELTestVideoPreview.h"
#import "ELImageProcessor.h"
#import "ELGraphView.h"


@interface ViewController : UIViewController {
    NSTimer* measureController;

}

@property (strong, nonatomic) ELTestVideoPreview* testVideoPreview;
@property (strong, nonatomic) ELCameraMonitor* cameraMonitor;
@property (strong, nonatomic) ELGraphView* graphView;
@property (strong, nonatomic) IBOutlet UIButton *controlButton;

- (IBAction)start:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;
@property (weak, nonatomic) IBOutlet UILabel *testResultLabel;

@end


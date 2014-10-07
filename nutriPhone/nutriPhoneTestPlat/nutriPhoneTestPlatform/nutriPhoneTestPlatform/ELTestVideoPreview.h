//
//  ELTestVideoPreview.h
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-7.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCameraMonitor.h"

@interface ELTestVideoPreview : UIView {
    
}

@property (nonatomic,strong) ELCameraMonitor* cameraMonitor;

- (id) initTestView;


@end

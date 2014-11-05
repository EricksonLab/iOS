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

- (id) initTestView;
- (BOOL) buildConnectionWithCameraMonitor:(ELCameraMonitor *)cameraMonitor;


@end

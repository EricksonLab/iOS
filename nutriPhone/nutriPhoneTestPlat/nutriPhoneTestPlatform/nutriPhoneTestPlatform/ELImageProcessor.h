//
//  ELImageProcessor.h
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/30/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELImage.h"

@interface ELImageProcessor : NSObject

+(ELImage*)clipELImage:(ELImage*)sourceImage
                 AtTop:(uint)top Left:(uint)left
                Bottom:(uint)bottom Rightt:(uint)right;

+(NSArray*)sumUpHueAlongAxisYFrom:(ELImage*)sourceImage Bias:(int)bias;

@end

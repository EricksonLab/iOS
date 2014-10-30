//
//  ELImage.h
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-30.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct{
    int r;
    int g;
    int b;
    int a;
}ELColor;

@interface ELImage: NSObject {
    UInt8 p;
}

@property (assign, nonatomic) size_t width,height;
@property (assign, nonatomic) UInt8* imageBufferRef;

-(ELColor) colorAtLine:(uint)x Row:(uint)y;
-(void) setColorAtLine:(uint)x Row:(uint)y Color:(ELColor)color;

@end

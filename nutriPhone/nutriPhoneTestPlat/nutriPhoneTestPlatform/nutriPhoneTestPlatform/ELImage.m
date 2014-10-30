//
//  ELImage.m
//  nutriPhoneTestPlatform
//
//  Created by Ning Wu on 14-10-30.
//  Copyright (c) 2014年 EricksonLab. All rights reserved.
//

#import "ELImage.h"

@implementation ELImage

-(id)init{
    self = [super init];
    if (self) {
        p=(UInt8 *)malloc(sizeof(UInt8)*20);
        p[10]=3;
    }
    return self;
}

-(void) print{
    NSLog(@"%d",p[10]);
}

@end

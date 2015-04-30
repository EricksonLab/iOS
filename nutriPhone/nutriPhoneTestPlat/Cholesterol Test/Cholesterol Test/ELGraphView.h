//
//  ELGraphView.h
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/31/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ELGraphViewScaleMannual = 0,
    ELGraphViewScaleAutoXY = 1,
    ELGraphViewScaleAutoX = 2,
    ELGraphViewScaleAutoY = 3,
}ELGraphViewScaleMode;

@interface ELGraphView : UIView {
    
    int viewHeight,viewWidth;
    float visionLeft,visionRight,visionTop,visionBottom;
    ELGraphViewScaleMode scaleMode;
    BOOL scaleAutoX,scaleAutoY;
}

@property (atomic, strong) NSArray* internalDataValueY;
@property (atomic, strong) NSArray* internalDataValueX;;



- (id)initWithFrame:(CGRect)frame;
- (id)initDefault;
- (void)setGraphViewScaleMode:(ELGraphViewScaleMode)graphViewScaleMode;
- (void)setViewVisionLeft:(int)left Top:(int)top Right:(int)right Bottom:(int)bottom;
- (void)updateInternalDataY:(NSArray*)data;
- (void)updateInternalDataX:(NSArray*)data;
- (void)updateInternalDataY:(NSArray*)dataY DataX:(NSArray*)dataX;

@end
//
//  ELGraphView.m
//  nutriPhoneTestPlatform
//
//  Created by NutriPhone on 10/31/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ELGraphView.h"

@implementation ELGraphView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Initialize methods
- (id)initDefault{
    CGRect frame = CGRectMake(10, 260, 300, 240);
    return [self initWithFrame:frame];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scaleMode = ELGraphViewScaleAutoXY;
        [self setGraphViewScaleMode:scaleMode];
        viewHeight = CGRectGetHeight(frame);
        viewWidth = CGRectGetWidth(frame);
        internalDataValueY = nil;
        internalDataValueX = nil;
    }
    return self;
}
#pragma mark - View settings

- (void)setGraphViewScaleMode:(ELGraphViewScaleMode)graphViewScaleMode {
    if (graphViewScaleMode == ELGraphViewScaleAutoXY) {
        scaleAutoX = YES;
        scaleAutoY = YES;
    } else if (graphViewScaleMode == ELGraphViewScaleAutoX) {
        scaleAutoX = YES;
        scaleAutoY = NO;
    } else if (graphViewScaleMode == ELGraphViewScaleAutoXY) {
        scaleAutoX = NO;
        scaleAutoY = YES;
    } else if (graphViewScaleMode == ELGraphViewScaleAutoXY) {
        scaleAutoX = NO;
        scaleAutoY = NO;
    }
}

- (void)setViewVisionLeft:(int)left Top:(int)top Right:(int)right Bottom:(int)bottom {
    visionLeft = left;
    visionRight = right;
    visionTop = top;
    visionBottom = bottom;
}

#pragma mark - Update data
- (void)updateInternalDataY:(NSArray*)data{
    internalDataValueY = data;
}

- (void)updateInternalDataX:(NSArray*)data{
    internalDataValueX = data;
}

- (void)updateInternalDataY:(NSArray*)dataY DataX:(NSArray*)dataX{
    internalDataValueY = dataY;
    internalDataValueX = dataX;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // What rectangle am I filling?
    CGRect bounds = [self bounds];
    // Where is its center?
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    // From the center how far out to a corner?
    //float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    // Get the context being drawn upon
    CGContextRef context = UIGraphicsGetCurrentContext();
    // All lines will be drawn 10 points wide
    CGContextSetLineWidth(context, 5);
    // Set the stroke color
    [[UIColor blackColor] setStroke];
    // Draw coordinary axis
    CGContextMoveToPoint(context, 0, bounds.size.height);
    CGContextAddLineToPoint(context,bounds.size.width,bounds.size.height);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context,0,bounds.size.width);
    CGContextStrokePath(context);
    //Prepare data
    // Draw curve
    if ((!internalDataValueX) && (!internalDataValueY)) {
        NSLog(@"No data to plot");
        return;
    }
    else if (!internalDataValueX || [internalDataValueX count]==0) {
        CGContextSetLineWidth(context, 3);
        [[UIColor redColor] setStroke];
        
        if (scaleAutoX) {
            visionLeft = 0.0;
            visionRight = [internalDataValueY count]-1.0;
            int tempVisionBottom = [self minValueInArray:internalDataValueY];
            int tempVisionTop = [self maxValueInArray:internalDataValueY];
            visionTop = tempVisionTop *1.1 - tempVisionBottom*0.1;
            visionBottom = tempVisionBottom *1.1 - tempVisionTop*0.1;
            NSLog(@"vison tempTop:%d,top:%f,tempBottom:%d,bottom:%f",tempVisionTop,visionTop,tempVisionBottom,visionBottom);
        }
        NSNumber * num = [internalDataValueY objectAtIndex:(int)visionRight];
        NSLog(@"%f",num.floatValue);
        for (int i=(int)visionLeft; i<(int)visionRight; i++) {
            float x1 = (float)viewWidth*i/(visionRight-visionLeft);
            float x2 = (float)viewWidth*(i+1)/(visionRight-visionLeft);
            NSNumber* number1 = [internalDataValueY objectAtIndex:i];
            float y1 = (float)viewHeight*(1-(number1.floatValue-visionBottom)/(visionTop-visionBottom));
            NSNumber* number2 = [internalDataValueY objectAtIndex:(i+1)];
            float y2 = (float)viewHeight*(1-(number2.floatValue-visionBottom)/(visionTop-visionBottom));
         //   NSLog(@"y1:%f y2,%f",y1,y2);
            CGContextMoveToPoint(context, x1, y1);
            CGContextAddLineToPoint(context, x2, y2);
        }
    }
    CGContextStrokePath(context);
}

- (float) maxValueInArray:(NSArray*)array {
    NSNumber* val = [array objectAtIndex:0];
    float max = val.floatValue;
    for (int i = 1; i<[array count];i++) {
        val = [array objectAtIndex:i];
        if (max<val.floatValue) max = val.floatValue;
    }
    return max;
}


- (float) minValueInArray:(NSArray*)array {
    NSNumber* val = [array objectAtIndex:0];
    float min = val.floatValue;
    for (int i = 1; i<[array count];i++) {
        val = [array objectAtIndex:i];
        if (min>val.floatValue) min = val.floatValue;
    }
    return min;
}

@end

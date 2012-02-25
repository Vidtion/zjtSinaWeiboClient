//
//  CustomScrollView.m
//  ImageZoomTest
//
//  Created by jtone on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomScrollView.h"


@implementation CustomScrollView
@synthesize doubelClicked;
@synthesize touchedPoint;
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    touchedPoint = [[touches anyObject] locationInView:self];    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch tapCount] == 2) {
        doubelClicked = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doubelClicked" object:self];
    }
}

@end

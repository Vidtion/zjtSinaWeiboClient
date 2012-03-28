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

-(void)postTapNotif
{
    if (!doubelClicked) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapClicked" object:self];
    }
}

//- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    doubelClicked = NO;
//    touchedPoint = [[touches anyObject] locationInView:self];    
//    UITouch *touch = [[event allTouches] anyObject];
//    if ([touch tapCount] == 2)
//    {
//        doubelClicked = YES;
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"doubelClicked" object:self];
//    }
//    else if([touch tapCount] == 1)
//    {
//        NSLog(@"1");
//        [self performSelector:@selector(postTapNotif) withObject:nil afterDelay:0.0];
//    }
//}

@end

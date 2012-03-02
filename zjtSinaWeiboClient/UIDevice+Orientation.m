//
//  UIDevice+Orientation.m
//  noCamera
//
//  Created by Wan Shaobo on 10/4/11.
//  Copyright 2011 Wondershare. All rights reserved.
//

#import "UIDevice+Orientation.h"

@implementation UIDevice(orientation)

static UIDeviceOrientation previousValidDeviceOrientation = UIDeviceOrientationLandscapeLeft;

+ (UIDeviceOrientation) validDeviceOrientation 
{
    return previousValidDeviceOrientation;
}

+ (void) setValidDeviceOrientation:(UIDeviceOrientation)orientation
{
    if (orientation == UIDeviceOrientationPortrait           ||
        orientation == UIDeviceOrientationPortraitUpsideDown ||
        orientation == UIDeviceOrientationLandscapeLeft      ||
        orientation == UIDeviceOrientationLandscapeRight) {
        previousValidDeviceOrientation = orientation;
    }
}

@end

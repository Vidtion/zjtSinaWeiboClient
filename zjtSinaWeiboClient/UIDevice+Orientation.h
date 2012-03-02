//
//  UIDevice+Orientation.h
//  noCamera
//
//  Created by Wan Shaobo on 10/4/11.
//  Copyright 2011 Wondershare. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice(orientation)

+ (UIDeviceOrientation) validDeviceOrientation;
+ (void) setValidDeviceOrientation:(UIDeviceOrientation)orientation;

@end

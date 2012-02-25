//
//  CustomScrollView.h
//  ImageZoomTest
//
//  Created by jtone on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomScrollView : UIScrollView {
    bool doubelClicked;
    CGPoint touchedPoint;
}
@property (readwrite) bool      doubelClicked;
@property (nonatomic) CGPoint   touchedPoint;
@end

//
//  UILabel+Size.h
//  noCamera
//
//  Created by Wan Shaobo on 6/16/11.
//  Copyright 2011 Wondershare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (Size) 

+(CGSize) calcLabelSizeWithString:(NSString *)string andFont:(UIFont *)font maxLines:(NSInteger)lines lineWidth:(float)lineWidth;
+(NSInteger) calcLabelLineWithString:(NSString *)string andFont:(UIFont *)font lineWidth:(float)lineWidth;

@end

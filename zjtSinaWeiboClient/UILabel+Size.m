//
//  UILabel+Size.m
//  noCamera
//
//  Created by Wan Shaobo on 6/16/11.
//  Copyright 2011 Wondershare. All rights reserved.
//

#import "UILabel+Size.h"


@implementation UILabel(Size)

+(CGSize) calcLabelSizeWithString:(NSString *)string andFont:(UIFont *)font maxLines:(NSInteger)lines lineWidth:(float)lineWidth
{
    float lineHeight = [ string sizeWithFont: font ].height; // Calculate the height of one line.
    if ( string == nil ) {
        return CGSizeMake(lineWidth, lineHeight);
    }
		
    // Get the total height, divide by the height of one line to get the # of lines.
    int numLines = [UILabel calcLabelLineWithString:string andFont:font lineWidth:lineWidth];
	
	if ( numLines > lines )
        numLines = lines; // Set the number of lines to the maximum allowed if it goes over.
    
    return CGSizeMake(lineWidth, (lineHeight*(float)numLines)); // multiply the # of lines 
    
}

+(NSInteger) calcLabelLineWithString:(NSString *)string andFont:(UIFont *)font lineWidth:(float)lineWidth
{
    float lineHeight = [ string sizeWithFont: font ].height;
    
    CGSize size = [string sizeWithFont:font 
                     constrainedToSize:CGSizeMake(lineWidth, lineHeight*1000.0f) 
                         lineBreakMode:UILineBreakModeTailTruncation]; 
    // Get the total height, divide by the height of one line to get the # of lines.
    return size.height / lineHeight;
}

@end

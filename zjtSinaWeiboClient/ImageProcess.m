//
//  ImageProcess.m
//  HHuan
//
//  Created by yonghongchen on 11-7-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageProcess.h"


@implementation UIImage (Resize) 

- (UIImage *) scaleToSize:(CGSize)size scaleMode:(ImageScaleMode)scaleMode
{
    UIImage *thumbnail;
    int originalImageHeight = self.size.height;
    
    int originalImageWidth = self.size.width;
    
    if(originalImageHeight <= size.height && originalImageWidth <= size.width)
    {
        return self;
    }
    else 
    {
        int originalX = 0;
        int originalY = 0;
        if (scaleMode == ISMFadeOut) {
            if ((float)originalImageWidth / originalImageHeight > (float)size.width / size.height)
            {
                originalImageWidth = ((float)originalImageWidth / originalImageHeight) * size.height;
                originalImageHeight = size.height;
                originalX = (originalImageWidth - size.width) / 2;
            }
            else
            {
                originalImageHeight = ((float)originalImageHeight / originalImageWidth) * size.width;
                originalImageWidth = size.width;
                originalY = (originalImageHeight - size.height) / 2;
            }
        }
        else if (scaleMode == ISMUpscaleFadeIn) {
            if ((float)originalImageWidth / originalImageHeight > (float)size.width / size.height) {
                originalImageHeight = ((float)originalImageHeight / originalImageWidth) * size.width;
                originalImageWidth = size.width;
                originalY = -(size.height - originalImageHeight) / 2;
            }
            else if ((float)originalImageWidth / originalImageHeight < (float)size.width / size.height) {
                originalImageWidth = ((float)originalImageWidth / originalImageHeight) *size.height;
                originalImageHeight = size.height;
                originalX = -(size.width - originalImageWidth) / 2;
            }
            else {
                originalImageWidth = size.width;
                originalImageHeight = size.height;
            }
        }
        else {
            if ((float)originalImageWidth / originalImageHeight > (float)size.width / size.height) {
                originalImageHeight = ((float)originalImageHeight / originalImageWidth) * size.width;
                originalImageWidth = size.width;
            }
            else if ((float)originalImageWidth / originalImageHeight < (float)size.width / size.height) {
                originalImageWidth = ((float)originalImageWidth / originalImageHeight) *size.height;
                originalImageHeight = size.height;
            }
            else {
                originalImageWidth = size.width;
                originalImageHeight = size.height;
            }
        }
        
        CGSize itemSize;
        if (scaleMode == ISMFadeOut) {
            itemSize = CGSizeMake(size.width, size.height);
        }
        else if (scaleMode == ISMUpscaleFadeIn){
            itemSize = CGSizeMake(size.width, size.height);
        }
        else {
            itemSize = CGSizeMake(originalImageWidth, originalImageHeight);
        }
        
        
        UIGraphicsBeginImageContext(itemSize);
        if (scaleMode == ISMUpscaleFadeIn) {
            [[UIColor blackColor] setFill];
            UIRectFill(CGRectMake(0, 0, itemSize.width, itemSize.height));
        }
        
        CGRect imageRect = CGRectMake(-originalX, -originalY, originalImageWidth, originalImageHeight);
        
        [self drawInRect:imageRect];
        
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return thumbnail;
}

- (UIImage *) scaleToSize:(CGSize) size{
	CGRect rectanger;
	rectanger.origin.x = 0;
	rectanger.origin.y = 0;
	rectanger.size=size;
	UIGraphicsBeginImageContext(rectanger.size);
	[self drawInRect:rectanger];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}
@end

//
//  ImageProcess.h
//  HHuan
//
//  Created by yonghongchen on 11-7-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThumbnailWidth            120
#define kThumbnailHeight           90

#define kDisplayWidth              270
#define kDisplayHeight             72

#define kSharePhotoCellWidth       270
#define kSharePhotoCellHeight      72

#define kImageScaleWidth           1024
#define kImageScaleHeight          768

typedef enum {
    ISMFadeIn,
    ISMUpscaleFadeIn,
    ISMFadeOut
}ImageScaleMode;

@interface UIImage (Resize)    

- (UIImage *) scaleToSize:(CGSize)size scaleMode:(ImageScaleMode)scaleMode;
- (UIImage *) scaleToSize:(CGSize) size;
@end

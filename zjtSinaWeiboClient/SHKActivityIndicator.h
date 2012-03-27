//
//  SHKActivityIndicator.h
//  ShareKit
//
//  Created by Nathan Weiner on 6/16/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import <Foundation/Foundation.h>

@interface SHKActivityIndicator : UIView
{
    UIView  *modalBackView;
	UILabel *centerMessageLabel;
	UILabel *subMessageLabel;
	
	UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) UILabel *centerMessageLabel;
@property (nonatomic, retain) UILabel *subMessageLabel;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIView  *modalBackView;

+ (SHKActivityIndicator *)currentIndicator;

- (void)show;
- (void)showInView:(UIView*)view;
- (void)hideAfterDelay:(NSTimeInterval)delay;
- (void)hide;
- (void)hidden;
- (void)displayActivity:(NSString *)m;
- (void)displayActivity:(NSString *)m inView:(UIView*)view;
- (void)displayCompleted:(NSString *)m;
- (void)setCenterMessage:(NSString *)message;
- (void)setSubMessage:(NSString *)message;
- (void)showSpinner;
- (void)setProperRotation;
- (void)setProperRotation:(BOOL)animated;
- (void)setRotationWithOritation:(UIDeviceOrientation)orientation animted:(BOOL)animated;

@end

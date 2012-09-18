//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"



@implementation PullRefreshTableViewController

@synthesize textPull, textRelease, textLoading, refreshFooterView, refreshLabel, refreshArrow, refreshSpinner;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
      [self setupStrings];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
      [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
      [self setupStrings];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    [self addPullToRefreshFooter];
}

- (void)setupStrings{
    textPull    = [[NSString alloc] initWithString:@"上拉加载更多..."];
    textRelease = [[NSString alloc] initWithString:@"松开即可加载..."];
    textLoading = [[NSString alloc] initWithString:@"加载中..."];
}

- (void)addPullToRefreshFooter {
    refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, REFRESH_FOOTER_HEIGHT)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.tableView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, REFRESH_FOOTER_HEIGHT - 40.0f, 320.0f, 20.0f)];
    lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lastUpdatedLabel.text = @"最后更新:今天10：30";
    lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
    lastUpdatedLabel.textColor = TEXT_COLOR;
    lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    lastUpdatedLabel.backgroundColor = [UIColor clearColor];
    lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
    lastUpdatedLabel.hidden = YES;
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, REFRESH_FOOTER_HEIGHT - 55.0f, 320.0f, 20.0f)];
    refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    refreshLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    refreshLabel.textColor = TEXT_COLOR;
    refreshLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    refreshLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.textAlignment = UITextAlignmentCenter;

    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_FOOTER_HEIGHT - 30) / 2),
                                    (floorf(REFRESH_FOOTER_HEIGHT - 55) / 2),
                                    30, 55);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_FOOTER_HEIGHT - 20) / 2), floorf((REFRESH_FOOTER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;

    [refreshFooterView addSubview:lastUpdatedLabel];
    [refreshFooterView addSubview:refreshLabel];
    [refreshFooterView addSubview:refreshArrow];
    [refreshFooterView addSubview:refreshSpinner];
    [self.tableView setTableFooterView:refreshFooterView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (contentOffsetY < 0)
            self.tableView.contentInset = UIEdgeInsetsOriginal;        
        else if (contentOffsetY <= REFRESH_FOOTER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMiddle;
    } else if (isDragging && contentOffsetY > 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (contentOffsetY > REFRESH_FOOTER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}


- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsFinal;
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (contentOffsetY >= REFRESH_FOOTER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}



- (void)stopLoading {
    isLoading = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日 hh:mm"];
    lastUpdatedLabel.text = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI , 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)dealloc {
    [refreshFooterView release];
    [refreshLabel release];
    [lastUpdatedLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [super dealloc];
}

@end

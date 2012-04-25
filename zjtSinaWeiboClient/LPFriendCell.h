//
//  LPFriendCell.h
//  HHuan
//
//  Created by yonghongchen on 11-11-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "LPBaseCell.h"

@class LPFriendCell;

@protocol LPFriendCellDelegate <NSObject>

-(void)lpCellDidClicked:(LPFriendCell*)cell;

@end

@interface LPFriendCell : LPBaseCell {
    IBOutlet    UILabel         *nameLabel;
    IBOutlet    UIButton        *invitationBtn;
    IBOutlet    UIImageView     *headerView;
    NSString                    *lidStr;
    NSNumber                    *type;
    IBOutlet UIImageView        *cellBG;
    id<LPFriendCellDelegate>    _delegate;
    NSIndexPath *_lpCellIndexPath;
}
@property (nonatomic, retain) UIButton          *invitationBtn;
@property (nonatomic, retain) UILabel           *nameLabel;
@property (nonatomic, retain) UIImageView       *headerView;
@property (nonatomic, retain) NSString          *lidStr;
@property (nonatomic, retain) NSNumber          *type;
@property (nonatomic, retain) UIImageView       *cellBG;
@property (nonatomic, assign) id<LPFriendCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *lpCellIndexPath;

@end


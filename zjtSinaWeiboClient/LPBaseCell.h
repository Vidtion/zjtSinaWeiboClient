//
//  LPBaseCell.h
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPBaseCell : UITableViewCell

+ (UINib *)nib;

+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style cellID:(NSString*)cellID;
+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;

+ (NSString *)cellIdentifier;

- (void)reset;

@end

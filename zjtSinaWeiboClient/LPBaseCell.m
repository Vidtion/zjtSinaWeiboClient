//
//  LPBaseCell.m
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LPBaseCell.h"

@implementation LPBaseCell

- (void)reset
{
    
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style cellID:(NSString*)cellID
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[self alloc] initWithStyle:style reuseIdentifier:cellID] autorelease];
    }
    return cell;
}

+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style
{
    NSString *cellID = nil;
    if (style == UITableViewCellStyleDefault) 
        cellID = @"UITableViewCellStyleDefault";
    else if (style == UITableViewCellStyleValue1) 
        cellID = @"UITableViewCellStyleValue1";
    else if (style == UITableViewCellStyleValue2)
        cellID = @"UITableViewCellStyleValue2";
    else if (style == UITableViewCellStyleSubtitle)
        cellID = @"UITableViewCellStyleSubtitle";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[self alloc] initWithStyle:style
                            reuseIdentifier:cellID] autorelease];
    }
    return cell;
}

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

+ (NSString *)nibName {
    return [self cellIdentifier];
}

+ (UINib *)nib {
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]]; 
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

@end
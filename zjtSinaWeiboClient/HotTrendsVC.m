//
//  HotTrendsVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-26.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "HotTrendsVC.h"
#import "WeiBoMessageManager.h"

@interface HotTrendsVC ()

@end

@implementation HotTrendsVC
@synthesize dataSourceArr = _dataSourceArr;

-(void)dealloc
{
    self.dataSourceArr = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"今日热门话题";
    }
    return self;
}

-(id)initWithDataSourceArr:(NSArray*)arr stylee:(UITableViewStyle)style
{
    self = [self initWithStyle:style];
    if (self) {
        self.dataSourceArr = arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[WeiBoMessageManager getInstance]getHOtTrendsDaily];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetHotTrend:) name:MMSinaGotHotCommentDaily object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotHotCommentDaily object:nil];
    [super viewDidUnload];  
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)didGetHotTrend:(NSNotification*)sender
{
    self.dataSourceArr = sender.object;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *name = [[_dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    if (name && name.length != 0) {
        cell.textLabel.text = name;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end

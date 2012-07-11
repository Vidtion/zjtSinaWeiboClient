//
//  POIViewController.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "POIViewController.h"
#import "SHKActivityIndicator.h"

@interface POIViewController ()

@end

@implementation POIViewController
@synthesize locationManager = _locationManager;
@synthesize coordinate = _coordinate;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _manager = [WeiBoMessageManager getInstance];
    }
    return self;
}

- (void)dealloc
{
    self.locationManager = nil;
    if (_poisArr) {
        [_poisArr release];
        _poisArr = nil;
    }
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (_locationManager) {
        _locationManager.delegate = nil;
        [_locationManager release];
        _locationManager = nil;
    }
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGotPois:) name:MMSinaGotPois object:nil];
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在定位..." inView:self.view];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)didGotPois:(NSNotification*)sender
{
    if (_poisArr) {
        [_poisArr release];
        _poisArr = nil;
    }
    
    _poisArr = [sender.object retain];
    [self.tableView reloadData];
    
    [[SHKActivityIndicator currentIndicator] hide];
}

#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位出错");
    [[SHKActivityIndicator currentIndicator] hide];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    if (!newLocation) {
        [self locationManager:manager didFailWithError:(NSError *)NULL];
        return;
    }
    
    if (signbit(newLocation.horizontalAccuracy)) {
		[self locationManager:manager didFailWithError:(NSError *)NULL];
		return;
	}
    
    [manager stopUpdatingLocation];
    
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    _coordinate.latitude = newLocation.coordinate.latitude;
    _coordinate.longitude = newLocation.coordinate.longitude;
    [_manager getPoisWithCoodinate:_coordinate queryStr:nil];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_poisArr == nil) {
        return 0;
    }
    return [_poisArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    POI *p = [_poisArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = p.title;
    cell.detailTextLabel.text = p.address;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    POI *p = [_poisArr objectAtIndex:indexPath.row];
    if (p == nil) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(poisCellDidSelected:)]) {
        [_delegate poisCellDidSelected:p];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

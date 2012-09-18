//
//  AppDelegate.m
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "FollowerVC.h"
#import "SettingVC.h"
#import "ProfileVC.h"
#import "FollowAndFansVC.h"
#import "MetionsStatusesVC.h"
#import "ZJTProfileViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjContext = _managedObjContext;
@synthesize managedObjModel = _managedObjModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.tag = 0;
    
    FirstViewController *firstViewController = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    MetionsStatusesVC *m = [[MetionsStatusesVC alloc]initWithNibName:@"FirstViewController" bundle:nil];
    ZJTProfileViewController *profile = [[[ZJTProfileViewController alloc] initWithNibName:@"ZJTProfileViewController" bundle:nil] autorelease ];
    FollowAndFansVC *followingVC = [[[FollowAndFansVC alloc] initWithNibName:@"FollowAndFansVC" bundle:nil] autorelease];
    SettingVC *settingVC = [[[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil] autorelease];
    
    followingVC.title = @"好友";
    m.title = @"@我";
    profile.title = @"我的微博";
    
    UINavigationController *nav1 = [[[UINavigationController alloc]initWithRootViewController:firstViewController] autorelease];
    UINavigationController *nav2 = [[[UINavigationController alloc] initWithRootViewController:m] autorelease];
    UINavigationController *nav3 = [[[UINavigationController alloc] initWithRootViewController:followingVC] autorelease];
    UINavigationController *nav4 = [[[UINavigationController alloc] initWithRootViewController:profile] autorelease];
    UINavigationController *nav5 = [[[UINavigationController alloc] initWithRootViewController:settingVC] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:nav1, nav2,nav3,nav4,nav5,nil];
//    self.tabBarController.selectedIndex = 2;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible]; 

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end

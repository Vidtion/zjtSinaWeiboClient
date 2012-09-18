//
//  CoreDataManager.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-22.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

static CoreDataManager * instance;

@implementation CoreDataManager
@synthesize managedObjContext = _managedObjContext;
@synthesize managedObjModel = _managedObjModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(id) init{
    self = [super init];
    if (self) {
        NSManagedObjectContext *context = self.managedObjContext;
        if (context == nil) {
            NSLog(@"create managedObjContext error");
        }
    }
    return self;
}

+(CoreDataManager *) getInstance{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[CoreDataManager alloc] init];
        }
    }
    return instance;
}

- (void)insertImageToCD:(NSData*)data url:(NSString*)url
{
    if ([self readImageFromCD:url] != nil) {
        return;
    }
    Images *image = (Images *)[NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:_managedObjContext];
    image.createDate = [NSDate date];
    image.url = url;
    image.data = data;
    
    NSError *error;
	if (![_managedObjContext save:&error]) {
		// Handle the error.
	}
}

- (Images*)readImageFromCD:(NSString*)url 
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Images" inManagedObjectContext:_managedObjContext];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"url==%@",url];
    [fetch setPredicate:pred];
    [fetch setEntity:entity];
    
    NSError *error = nil;
	NSMutableArray *resultsArr = [[_managedObjContext executeFetchRequest:fetch error:&error] mutableCopy];
	if (resultsArr == nil || [resultsArr count] == 0) {
        [fetch release];
        [resultsArr release];
		return nil;
	}
    
    Images *image = [[resultsArr objectAtIndex:0] retain];
    
    [resultsArr release];
    [fetch release];
    
    return [image autorelease];
}

- (void)insertStatusesToCD:(Status*)sts index:(int)theIndex isHomeLine:(BOOL) isHome
{
    StatusCDItem *statusItem = (StatusCDItem *)[NSEntityDescription insertNewObjectForEntityForName:@"StatusCDItem" inManagedObjectContext:_managedObjContext];
    
    if (sts.retweetedStatus) {
        statusItem.retweetedStatus = (StatusCDItem *)[NSEntityDescription insertNewObjectForEntityForName:@"StatusCDItem" inManagedObjectContext:_managedObjContext];
        
        statusItem.retweetedStatus = [sts.retweetedStatus updateStatusCDItem:statusItem.retweetedStatus index:-1 isHomeLine:NO];
    }
    [sts updateStatusCDItem:statusItem index:theIndex isHomeLine:isHome];
    
    NSError *error;
	if (![_managedObjContext save:&error]) {
		// Handle the error.
	}
}

-(NSArray*)readStatusesFromCD
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StatusCDItem" inManagedObjectContext:_managedObjContext];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isHomeLine==YES"];
    [fetch setPredicate:pred];
    [fetch setEntity:entity];
    
    NSError *error = nil;
	NSMutableArray *resultsArr = [[_managedObjContext executeFetchRequest:fetch error:&error] mutableCopy];
	if (resultsArr == nil || [resultsArr count] == 0) {
        [fetch release];
        [resultsArr release];
		return nil;
	}
    
    [resultsArr autorelease];
    [fetch release];
    
    return resultsArr;
}

-(void)cleanEntityRecords:(NSString*)entityName
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjContext];
    [fetch setEntity:entity];
    
    NSError *error = nil;
	NSMutableArray *resultsArr = [[_managedObjContext executeFetchRequest:fetch error:&error] mutableCopy];
	if (resultsArr == nil || [resultsArr count] == 0) {
        [fetch release];
        [resultsArr release];
		return ;
	}
    
    // Delete the managed object
    for (NSManagedObject *imageToDelete in resultsArr)
    {
        [_managedObjContext deleteObject:imageToDelete];
    }
    
    if (![_managedObjContext save:&error]) {
        // Handle the error.
    }
    
    [resultsArr release];
    [fetch release];
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSLog(@"basePath = %@",basePath);
    return basePath;
}

- (NSManagedObjectContext *) managedObjContext {
	
    if (_managedObjContext != nil) {
        return _managedObjContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _managedObjContext = [[NSManagedObjectContext alloc] init];
        [_managedObjContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjContext;
}


- (NSManagedObjectModel *)managedObjModel {
	
    if (_managedObjModel != nil) {
        return _managedObjModel;
    }
    _managedObjModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return _managedObjModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"ImageCacheCoreData.sqlite"]];
	NSLog(@"sql path = %@",storeUrl);
    
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle the error.
    }    
	
    return _persistentStoreCoordinator;
}

@end

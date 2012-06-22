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

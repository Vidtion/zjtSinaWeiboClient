//
//  CoreDataManager.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-22.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Images.h"
#import "UserCDItem.h"
#import "StatusCDItem.h"
#import "Status.h"

@interface CoreDataManager : NSObject
{
    NSManagedObjectContext         *_managedObjContext;
    NSManagedObjectModel           *_managedObjModel;
    NSPersistentStoreCoordinator   *_persistentStoreCoordinator;
}

@property (nonatomic,retain,readonly) NSManagedObjectContext         *managedObjContext;
@property (nonatomic,retain,readonly) NSManagedObjectModel           *managedObjModel;
@property (nonatomic,retain,readonly) NSPersistentStoreCoordinator   *persistentStoreCoordinator;

+ (CoreDataManager *) getInstance;
- (void)insertImageToCD:(NSData*)data url:(NSString*)url;
- (Images*)readImageFromCD:(NSString*)url;
- (void)insertStatusesToCD:(Status*)sts index:(int)theIndex isHomeLine:(BOOL) isHome;
- (NSArray*)readStatusesFromCD;
-(void)cleanEntityRecords:(NSString*)entityName;
@end

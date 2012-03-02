//
//  SHKDefine.h
//  ShareKit
//
//  Created by Shi Pengfei on 9/19/11.
//  Copyright 2011 WS. All rights reserved.
//


typedef enum {
    SharingTableViewCellSharing    = 0,
    SharingTableViewCellCanceled   = 1,
    SharingTableViewCellRetry      = 2,
	SharingTableViewCellWaiting    = 3,
	SharingTableViewCellSucceed    = 4,
	SharingTableViewCellFailed     = 5,
	SharingTableViewNotSupported   = 6
} SharingTableViewCellState;

#define SHKdegreesToRadians(x) (M_PI * x / 180.0)
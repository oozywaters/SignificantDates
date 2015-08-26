//
//  SDSyncEngine.h
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 26/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

typedef enum {
    SDObjectSynced = 0,
} SDObjectSyncStatus;

@interface SDSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (SDSyncEngine *)sharedEngine;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;

@end

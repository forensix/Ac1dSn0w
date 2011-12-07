// -----------------------------------------------------------------------------
//  ASClientWatchdog.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

#import "MobileDevice.h"

@interface ASClientWatchdog : NSObject
{
@private
    NSNotificationCenter    *_defaultCenter;
    NSMutableDictionary     *_clientName; // ASClientWatchdog+Registration
}

+ (ASClientWatchdog *)sharedWatchdog;

- (BOOL)clientConnected;
- (BOOL)clientCompatible;
- (BOOL)clientEnteredDFUMode;
- (BOOL)clientEnteredRecoveryMode;
- (am_device *)clientDevice:(BOOL)reconnect;
- (am_recovery_device *)recoveryDevice;

@end

// -----------------------------------------------------------------------------
//  ASClientWatchdog+Registration.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 23.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

#import "ASClientWatchdog.h"

@interface ASClientWatchdog (Registration)

- (void)registerClient:(am_device *)client;
- (void)deregisterClient:(am_device *)client;
- (NSString *)nameForClient:(am_device *)client;

@end

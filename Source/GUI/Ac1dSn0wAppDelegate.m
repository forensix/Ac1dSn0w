// -----------------------------------------------------------------------------
//  Ac1dSn0wAppDelegate.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "Ac1dSn0wAppDelegate.h"
#import "ASClientWatchdog.h"

#include "libAc1d.h"

@implementation Ac1dSn0wAppDelegate

@synthesize window;

- (void)setupClientWatchdog
{
    (void)[ASClientWatchdog sharedWatchdog];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupClientWatchdog];
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
    // Clean-up!
    ac1d_exit();
}


@end

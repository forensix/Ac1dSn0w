// -----------------------------------------------------------------------------
//  ASGeneralViewController.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 19.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASGeneralViewController.h"
#import "ASClientDevice.h"
#import "ASClientDeviceNotificationCenter.h"

@interface ASGeneralViewController ()

- (void)setupInitialValues;
- (void)cleanupInitialValues;

- (void)registerAtNotificationCenter;
- (void)deregisterFromNotificationCenter;

@end

@implementation ASGeneralViewController

// -----------------------------------------------------------------------------
#pragma mark Injection
// -----------------------------------------------------------------------------

@synthesize imeiLabel       = _imeiLabel;
@synthesize serialLabel     = _serialLabel;
@synthesize deviceNameLabel = _deviceNameLabel;
@synthesize modelLabel      = _modelLabel;
@synthesize firmwareLabel   = _firmwareLabel;
@synthesize bootloaderLabel = _bootloaderLabel;
@synthesize basebandLabel   = _basebandLabel;
@synthesize pwndevteamLabel = _pwndevteamLabel;


// -----------------------------------------------------------------------------
#pragma mark Cleanup
// -----------------------------------------------------------------------------

- (void)dealloc
{
    [self deregisterFromNotificationCenter];
    [self cleanupInitialValues];
    [super dealloc];
}


- (void)cleanupInitialValues
{
    RELEASE_SAFELY(_imeiLabel);
    RELEASE_SAFELY(_serialLabel);
    RELEASE_SAFELY(_deviceNameLabel);
    RELEASE_SAFELY(_modelLabel);
    RELEASE_SAFELY(_firmwareLabel);
    RELEASE_SAFELY(_bootloaderLabel);
    RELEASE_SAFELY(_basebandLabel);
    RELEASE_SAFELY(_pwndevteamLabel);
}


// -----------------------------------------------------------------------------
#pragma mark Setup
// -----------------------------------------------------------------------------

- (void)awakeFromNib
{
    [self setupInitialValues];
    [self registerAtNotificationCenter];
}



- (void)setupInitialValues
{
}


// -----------------------------------------------------------------------------
#pragma mark Observer
// -----------------------------------------------------------------------------

- (void)registerAtNotificationCenter
{
    ASClientDeviceNotificationCenter *notificationCenter
    = [ASClientDeviceNotificationCenter sharedCenter];
    
    [notificationCenter
     registerObserver:self
     name:NSStringFromClass([self class])
     object:nil];
}


- (void)deregisterFromNotificationCenter
{
    ASClientDeviceNotificationCenter *notificationCenter
    = [ASClientDeviceNotificationCenter sharedCenter];
    
    [notificationCenter
     deregisterObserver:self
     name:NSStringFromClass([self class])
     object:nil];    
}

// -----------------------------------------------------------------------------
#pragma mark Update
// -----------------------------------------------------------------------------

- (void)updateImeiLabel
{
    if (![ASClientDevice imei])
        return;
    [self.imeiLabel setStringValue:[ASClientDevice imei]];
}


- (void)updateSerialLabel
{
    if (![ASClientDevice serial])
        return;
    [self.serialLabel setStringValue:[ASClientDevice serial]];
}


- (void)updateDeviceNameLabel
{
    if (![ASClientDevice deviceName])
        return;
    [self.deviceNameLabel setStringValue:[ASClientDevice deviceName]];
}


- (void)updateModelLabel
{
    if (![ASClientDevice model])
        return;
    [self.modelLabel setStringValue:[ASClientDevice model]];
}


- (void)updateFirmwareLabel
{
    if (![ASClientDevice firmware])
        return;
    [self.firmwareLabel setStringValue:[ASClientDevice firmware]];
}


- (void)updateBootloaderLabel
{
    if (![ASClientDevice bootloader])
        return;
    [self.bootloaderLabel setStringValue:[ASClientDevice bootloader]];
}


- (void)updateBasebandLabel
{
    if (![ASClientDevice baseband])
        return;
    [self.basebandLabel setStringValue:[ASClientDevice baseband]];
}


- (void)updateLabels
{
    [self updateImeiLabel];
    [self updateSerialLabel];
    [self updateDeviceNameLabel];
    [self updateModelLabel];
    [self updateFirmwareLabel];
    [self updateBootloaderLabel];
    [self updateBasebandLabel];
}


- (void)resetLabels
{
    [self.imeiLabel setStringValue:@"N/A"];
    [self.serialLabel setStringValue:@"N/A"];
    [self.deviceNameLabel setStringValue:@"N/A"];
    [self.modelLabel setStringValue:@"N/A"];
    [self.firmwareLabel setStringValue:@"N/A"];
    [self.bootloaderLabel setStringValue:@"N/A"];
    [self.basebandLabel setStringValue:@"N/A"];
}


// -----------------------------------------------------------------------------
#pragma mark ASClientDeviceDataSource
// -----------------------------------------------------------------------------

- (void)clientWasConnected
{
    [self updateLabels];
}


- (void)clientWasDisconnected:(NSNotification *)notification
{
    [self resetLabels];
}


@end

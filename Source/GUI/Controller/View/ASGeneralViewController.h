// -----------------------------------------------------------------------------
//  ASGeneralViewController.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 19.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

#import "ASClientDeviceDataSource.h"

@interface ASGeneralViewController : NSObject
<
    ASClientDeviceDataSource
>
{
    NSTextField *_imeiLabel;
    NSTextField *_serialLabel;
    NSTextField *_deviceNameLabel;
    NSTextField *_modelLabel;
    NSTextField *_firmwareLabel;
    NSTextField *_bootloaderLabel;
    NSTextField *_basebandLabel;
    NSTextField *_pwndevteamLabel;
}

@property (retain) IBOutlet NSTextField *imeiLabel;
@property (retain) IBOutlet NSTextField *serialLabel;
@property (retain) IBOutlet NSTextField *deviceNameLabel;
@property (retain) IBOutlet NSTextField *modelLabel;
@property (retain) IBOutlet NSTextField *firmwareLabel;
@property (retain) IBOutlet NSTextField *bootloaderLabel;
@property (retain) IBOutlet NSTextField *basebandLabel;
@property (retain) IBOutlet NSTextField *pwndevteamLabel;

@end

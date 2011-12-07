// -----------------------------------------------------------------------------
//  ASClientDevice.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 19.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

@interface ASClientDevice : NSObject

+ (NSString *)imei;
+ (NSString *)serial;
+ (NSString *)device;
+ (NSString *)deviceName;
+ (NSString *)model;
+ (NSString *)firmware;
+ (NSString *)bootloader;
+ (NSString *)baseband;
+ (NSString *)name;

+ (void)enterRecoveryMode;
+ (void)exitRecoveryMode;
+ (void)reboot;
+ (void)deactivate;

@end

// -----------------------------------------------------------------------------
//  ASClientDevice.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 19.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASClientDevice.h"
#import "ASClientWatchdog.h"

#import "MobileDevice.h"

/*
 * Possible values for cfstring:
 * ActivationState
 * ActivationStateAcknowledged
 * BasebandBootloaderVersion
 * BasebandVersion
 * BluetoothAddress
 * BuildVersion
 * DeviceCertificate
 * DeviceClass
 * DeviceName
 * DevicePublicKey
 * FirmwareVersion
 * HostAttached
 * IntegratedCircuitCardIdentity
 * InternationalMobileEquipmentIdentity
 * InternationalMobileSubscriberIdentity
 * ModelNumber
 * PhoneNumber
 * ProductType
 * ProductVersion
 * ProtocolVersion
 * RegionInfo
 * SBLockdownEverRegisteredKey
 * SIMStatus
 * SerialNumber
 * SomebodySetTimeZone
 * TimeIntervalSince1970
 * TimeZone
 * TimeZoneOffsetFromUTC
 * TrustedHostAttached
 * UniqueDeviceID
 * Uses24HourClock
 * WiFiAddress
 * iTunesHasConnected
 */
#define IMEI        CFSTR("InternationalMobileEquipmentIdentity")
#define SERIAL      CFSTR("SerialNumber")
#define DEVICE      CFSTR("ProductType")
#define MODEL       CFSTR("ModelNumber")
#define FIRMWARE    CFSTR("ProductVersion")
#define BOOTLOADER  CFSTR("BasebandBootloaderVersion")
#define BASEBAND    CFSTR("BasebandVersion")
#define NAME        CFSTR("DeviceName")

@implementation ASClientDevice

+ (BOOL)deviceConnected
{
    return
    [[ASClientWatchdog sharedWatchdog] clientConnected];
}


+ (BOOL)recoveryDeviceConnected
{
    return
    [[ASClientWatchdog sharedWatchdog] clientEnteredRecoveryMode];
}


+ (am_device *)clientDevice:(BOOL)reconnect
{
    return
    [[ASClientWatchdog sharedWatchdog] clientDevice:reconnect];
}


+ (am_recovery_device *)recoveryDevice
{
    return
    [[ASClientWatchdog sharedWatchdog] recoveryDevice];
}


+ (NSString *)imei
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, IMEI);
}


+ (NSString *)serial
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, SERIAL);
}


+ (NSString *)device
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, DEVICE);    
}


+ (NSString *)deviceName
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, DEVICE);
}


+ (NSString *)model
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, MODEL);
}


+ (NSString *)firmware
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, FIRMWARE);
}


+ (NSString *)bootloader
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, BOOTLOADER);
}


+ (NSString *)baseband
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, BASEBAND);
}


+ (NSString *)name
{
    if (![self deviceConnected])
        return nil;
    am_device *clientDevice = [self clientDevice:NO];
    return (NSString *)AMDeviceCopyValue(clientDevice, 0, NAME);
}


+ (void)enterRecoveryMode
{
    if (![self deviceConnected])
        return;
    // Do an explicit reconnect!
    am_device *clientDevice = [self clientDevice:YES];
    if (MDERR_OK != AMDeviceEnterRecovery(clientDevice)) { }
}


+ (void)exitRecoveryMode
{
    if (![self recoveryDeviceConnected])
        return;
    am_recovery_device *recoveryDevice = [self recoveryDevice];
    // TODO: Check return values.
    (void)AMRecoveryModeDeviceSetAutoBoot(recoveryDevice, 1, 1, 1, 1);
	(void)AMRecoveryModeDeviceReboot(recoveryDevice, 1, 1, 1, 1);
}


+ (void)reboot
{
    if (![self deviceConnected])
        return;
}


+ (void)deactivate
{
    if (![self deviceConnected])
        return;
}


@end

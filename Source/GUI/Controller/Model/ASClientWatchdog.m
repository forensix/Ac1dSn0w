// -----------------------------------------------------------------------------
//  ASClientWatchdog.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASClientWatchdog.h"
#import "ASClientWatchdog+Registration.h"
#import "ASClientDeviceNotifications.h"
#import "ASClientDevice.h"
#import "ASHelper.h"

struct am_device            *_clientDevice = NULL;
struct am_recovery_device   *_recoveryDevice = NULL;
BOOL                         _clientEnteredDFUMode;

void        clientCallback(struct am_device_notification_callback_info *info, void *foo);
static void dfuModeEnteredCallback(struct am_recovery_device *rdev);
static void recoveryModeEnteredCallback(struct am_recovery_device *rdev);
static void dfuModeDisconnectedCallback(struct am_recovery_device *rdev);
static void recoveryModeDisconnectedCallback(struct am_recovery_device *rdev);

@interface ASClientWatchdog ()

- (void)setupInitialValues;
- (void)cleanupInitialValues;

- (void)postThatDeviceWasConnectedNotification;
- (void)postThatDeviceWasDisconnectedNotification:(NSString *)deviceName;
- (void)postThatDeviceConnectionHasFailed;
- (void)postThatDeviceHasEnteredDFUModeNotification;
- (void)postThatDeviceHasEnteredRecoveryModeNotification;
- (void)postThatDeviceHasExitedRecoveryModeNotification;
- (void)postThatDeviceConnectionHasFailed;

- (BOOL)establishConnection;
- (void)closeConnection;

@end

@implementation ASClientWatchdog

- (void)dealloc
{
    [self cleanupInitialValues];
    [super dealloc];
}


- (void)cleanupInitialValues
{
    [_defaultCenter release];
    [_clientName release];
}


- (id)init
{
    if (nil != (self = [super init]))
    {
        [self setupInitialValues];
    }
    return self;
}

static ASClientWatchdog *sharedInstance = nil;

+ (ASClientWatchdog *)sharedWatchdog
{    
    if (nil == sharedInstance)
    {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}


- (void)setupMobileDevice
{
    struct am_device_notification *dn;
    AMDeviceNotificationSubscribe(
        (am_device_notification_callback)clientCallback,
        0,
        0,
        0,
        &dn);
   	
    AMRestoreRegisterForDeviceNotifications(
        dfuModeEnteredCallback,
        recoveryModeEnteredCallback,
        dfuModeDisconnectedCallback,
        recoveryModeDisconnectedCallback,
        0,
        NULL);
}


- (void)setupInitialValues
{
    _defaultCenter
    = [[NSNotificationCenter defaultCenter] retain];
    _clientName
    = [[NSMutableDictionary alloc] init];
    
    _clientEnteredDFUMode = NO;
    
    [self setupMobileDevice];
}


- (void)postThatDeviceWasConnectedNotification
{
    [_defaultCenter
     postNotificationName:ASClientDeviceConnectedNotification
     object:nil];    
}


- (void)postThatDeviceWasDisconnectedNotification:(NSString *)deviceName
{
    [_defaultCenter
     postNotificationName:ASClientDeviceDisconnectedNotification
     object:deviceName];
    
    // Clean-up
    [self closeConnection];
}


- (void)postThatDeviceConnectionHasFailed
{
    [_defaultCenter
     postNotificationName:ASClientDeviceDisconnectedNotification
     object:nil];    
}


- (void)postThatDeviceHasEnteredDFUModeNotification
{
    [_defaultCenter
     postNotificationName:ASClientDeviceEnteredDFUModeNotification
     object:nil];
}


- (void)postThatDeviceHasExitedDFUModeNotification
{
    [_defaultCenter
     postNotificationName:ASClientDeviceExitedDFUModeNotification
     object:nil];
}


- (void)postThatDeviceHasEnteredRecoveryModeNotification
{
    [_defaultCenter
     postNotificationName:ASClientDeviceEnteredRecoveryModeNotification
     object:nil];
}


- (void)postThatDeviceHasExitedRecoveryModeNotification
{
    [_defaultCenter
     postNotificationName:ASClientDeviceExitedRecoveryModeNotification
     object:nil];
}


- (BOOL)clientConnected
{
    return (_clientDevice != NULL) || (_recoveryDevice != NULL);
}


- (BOOL)clientCompatible
{
    // TODO:
    // Implement some specific stuff.
    return YES;
}


- (BOOL)clientEnteredDFUMode
{
    return _clientEnteredDFUMode;
}


- (BOOL)clientEnteredRecoveryMode
{
    return (_recoveryDevice != NULL);
}


- (am_device *)clientDevice:(BOOL)reconnect
{
    if (reconnect)
    {
        [self closeConnection];
        [self establishConnection];
    }
    
    return _clientDevice;
}


- (am_recovery_device *)recoveryDevice
{
    return _recoveryDevice;
}


void clientCallback(struct am_device_notification_callback_info *info, void *foo)
{
    unsigned int state = info->msg;
    NSString *clientName = @"N/A";

    switch (state)
    {
    case ADNCI_MSG_CONNECTED:
        [sharedInstance closeConnection];
        
        _clientDevice = info->dev;

        BOOL connectionEstablished 
        = [sharedInstance establishConnection];
        if (!connectionEstablished)
        {
            _clientDevice = NULL;
            [sharedInstance postThatDeviceConnectionHasFailed];
            break;
        }
        
        [sharedInstance registerClient:info->dev];
        [sharedInstance postThatDeviceWasConnectedNotification];
        
        break;
    case ADNCI_MSG_DISCONNECTED:
        _clientDevice = NULL;
        clientName = [sharedInstance nameForClient:info->dev];
        
        [sharedInstance deregisterClient:info->dev];
        [sharedInstance postThatDeviceWasDisconnectedNotification:clientName];
        
        break;
    case ADNCI_MSG_UNKNOWN:
    default:
        [ASHelper logError:@"Received unknow message"
                  forClass:[sharedInstance class]
              withSelector:NSSelectorFromString(@"clientCallback")];
        break;
    }
}


static void dfuModeEnteredCallback(struct am_recovery_device *rdev)
{
    _recoveryDevice = rdev;
    _clientEnteredDFUMode = YES;
    [sharedInstance postThatDeviceHasEnteredDFUModeNotification];
}


static void recoveryModeEnteredCallback(struct am_recovery_device *rdev)
{
    _recoveryDevice = rdev;
    [sharedInstance postThatDeviceHasEnteredRecoveryModeNotification];
}


static void dfuModeDisconnectedCallback(struct am_recovery_device *rdev)
{
    _recoveryDevice = NULL;
    _clientEnteredDFUMode = NO;
    [sharedInstance postThatDeviceHasExitedDFUModeNotification];
}


static void recoveryModeDisconnectedCallback(struct am_recovery_device *rdev)
{
    _recoveryDevice = NULL;
    [sharedInstance postThatDeviceHasExitedRecoveryModeNotification];
}


- (BOOL)establishConnection
{
    mach_error_t retval = 0;
    
    retval = AMDeviceConnect(_clientDevice);
    if (MDERR_OK != retval)
        goto error;
    
    retval = AMDeviceIsPaired(_clientDevice);
    if (!retval)
        goto error;
    
    retval = AMDeviceValidatePairing(_clientDevice);
    if (MDERR_OK != retval)
        goto error;
    
    retval = AMDeviceStartSession(_clientDevice);
    if (MDERR_OK != retval)
        goto error;
    
    // Success
    return YES;
error:
    [ASHelper logError:@"Could not establish a connection to the client"
              forClass:[self class]
          withSelector:_cmd];
    return NO;
}


- (void)closeConnection
{
    // TODO: Check return value.
    (void)AMDeviceDisconnect(_clientDevice);
    (void)AMDeviceStopSession(_clientDevice);
}


@end

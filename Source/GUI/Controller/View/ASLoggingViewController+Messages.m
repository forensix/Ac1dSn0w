// -----------------------------------------------------------------------------
//  ASLoggingViewController+Messages.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 23.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASLoggingViewController+Messages.h"

#import "ASClientDevice.h"

#define WAITING_FORMAT                  @"[%@]  Waiting for device..."
#define WAS_CONNECTED_FORMAT            @"\n[%@]  Device connected: %@"
#define WAS_DISCONNECTED_FORMAT         @"\n[%@]  Device disconnected: %@"
#define WILL_ENTER_RECOVERY_FORMAT      @"\n[%@]  Try to put device into recovery mode..."
#define HAS_ENTERED_RECOVERY_FORMAT     @"\n[%@]  Device has entered recovery mode"
#define HAS_EXITED_RECOVERY_FORMAT      @"\n[%@]  Device has exited recovery mode"
#define HAS_ENTERED_DFU_MODE_FORMAT     @"\n[%@]  Device has entered DFU mode"
#define HAS_EXITED_DFU_MODE_FORMAT      @"\n[%@]  Device has exited DFU mode"
#define TETHERED_BOOT_SUCCESS_FORMAT    @"\n[%@]  Device is booting tethered..."
#define TETHERED_BOOT_FAILED_FORMAT     @"\n[%@]  Device couldn't boot tethered!"
#define JAILBREAK_SUCCESS_FORMAT        @"\n[%@]  Jailbreaking device...\n[%@]  After reboot you can boot tethered..."
#define JAILBREAK_FAILED_FORMAT         @"\n[%@]  Device couldn't be jailbroken!"

#define NOT_CONNECTED_FORMAT            @"\n[%@]  No device connected or not in required mode!"
#define NOT_IN_DFU_MODE_FORMAT          @"\n[%@]  Device isn't in DFU Mode!"
#define NOT_COMPATIBLE_FORMAT           @"\n[%@]  Device not compatible with this jailbreak!"

#define PWNED_DFU_SUCCESS_FORMAT        @"\n[%@]  Device is now in pwned DFU Mode!"
#define PWNED_DFU_FAILED_FORMAT         @"\n[%@]  Couldn't put device into pwned DFU Mode!"

#define NOT_IN_RECOVERY_MODE_FORMAT     @"\n[%@]  Device isn't in Recovery Mode!"
#define DOWNLOAD_PROGRESS_FORMAT        @"\n[%@]  %@"
#define PATCHING_FIRMWARES_FORMAT       @"\n[%@]  Patching firmware files..."
#define PATCHING_FIRMWARES_FAIL_FORMAT  @"\n[%@]  Couldn't patch firmware files..."

#define NO_INTERNET_CONNECTION_FORMAT   @"\n[%@]  You need a functional internet connection if you\n[%@]  jailbreak/boot your device for the first time!"

@implementation ASLoggingViewController (Messages)

- (NSString *)dateString
{
    NSDateFormatter *dateFormatter
    = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat: @"HH:mm:ss"];
    
    NSDate *date = [NSDate date];
    return[dateFormatter stringFromDate:date];
}


- (NSString *)waitingForClientMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:WAITING_FORMAT, date];
    
    return message;
}


- (NSString *)clientWasConnectedMessage
{
    NSString *date = [self dateString];
    NSString *name = [ASClientDevice name];
    
    NSString *message 
    = [NSString stringWithFormat:WAS_CONNECTED_FORMAT, date, name];
    
    return message;
}


- (NSString *)clientWasDisconnectedMessage:(NSString *)clientName
{
    NSString *date = [self dateString];
    NSString *name = clientName;
    
    NSString *message 
    = [NSString stringWithFormat:WAS_DISCONNECTED_FORMAT, date, name];
    
    return message;
}


- (NSString *)clientWillEnterRecoveryModeMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:WILL_ENTER_RECOVERY_FORMAT, date];
    
    return message;
}


- (NSString *)clientHasEnteredRecoveryModeMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:HAS_ENTERED_RECOVERY_FORMAT, date];
    
    return message;
}


- (NSString *)clientHasExitedRecoveryModeMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:HAS_EXITED_RECOVERY_FORMAT, date];
    
    return message;    
}


- (NSString *)clientHasEnteredDFUModeMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:HAS_ENTERED_DFU_MODE_FORMAT, date];
    
    return message;
}


- (NSString *)clientHasExitedDFUModeMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:HAS_EXITED_DFU_MODE_FORMAT, date];
    
    return message;
}


- (NSString *)clientTetheredBootSuccessMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:TETHERED_BOOT_SUCCESS_FORMAT, date];
    
    return message;
}


- (NSString *)clientTetheredBootFailedMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:TETHERED_BOOT_FAILED_FORMAT, date];
    
    return message;
}

- (NSString *)clientJailbreakSuccessMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:JAILBREAK_SUCCESS_FORMAT, date, date];
    
    return message;
}


- (NSString *)clientJailbreakFailedMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:JAILBREAK_FAILED_FORMAT, date];
    
    return message;
}


- (NSString *)clientNotConnectedMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:NOT_CONNECTED_FORMAT, date];
    
    return message;
}


- (NSString *)clientNotInDfuModeMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:NOT_IN_DFU_MODE_FORMAT, date];
    
    return message;
}


- (NSString *)clientIncompatibleMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:NOT_COMPATIBLE_FORMAT, date];
    
    return message;
}


- (NSString *)clientPwnedDfuSuccessMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:PWNED_DFU_SUCCESS_FORMAT, date];
    
    return message;
}


- (NSString *)clientPwnedDfuFailedMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:PWNED_DFU_FAILED_FORMAT, date];
    
    return message;
}


- (NSString *)clientNotInRecoveryModeMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:NOT_IN_RECOVERY_MODE_FORMAT, date];
    
    return message;
}


- (NSString *)clientDownloadProgressMessage:(NSString *)string
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:DOWNLOAD_PROGRESS_FORMAT, date, string];
    
    return message;
}

- (NSString *)patchingFirmwaresMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:PATCHING_FIRMWARES_FORMAT, date];
    
    return message;
}


- (NSString *)patchingFirmwaresFailedMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:PATCHING_FIRMWARES_FAIL_FORMAT, date];
    
    return message;

}


- (NSString *)noInternetConnectionAvailableMessage
{
    NSString *date = [self dateString];
    
    NSString *message 
    = [NSString stringWithFormat:NO_INTERNET_CONNECTION_FORMAT, date, date];
    
    return message;
}


@end

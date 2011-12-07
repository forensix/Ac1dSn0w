// -----------------------------------------------------------------------------
//  ASClientDeviceDataSource.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 21.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

@protocol ASClientDeviceDataSource <NSObject>

@optional

// Note that we don't need to pass an object to know which
// instance has being called the corresponding method cause
// the calling instance is shared (Singleton).
- (void)clientWasConnected;
- (void)clientWasDisconnected:(NSNotification *)notification;
- (void)clientConnectionFailed;
- (void)clientHasEnteredDFUMode;
- (void)clientHasExitedDFUMode;
- (void)clientWillEnterRecoveryMode;
- (void)clientHasEnteredRecoveryMode; 
- (void)clientHasExitedRecoveryMode;
- (void)clientTetheredBootSuccess;
- (void)clientTetheredBootFailed;
- (void)clientJailbreakSuccess;
- (void)clientJailbreakFailed;
- (void)clientNotConnected;
- (void)clientNotInDfuMode;
- (void)clientIncompatible;
- (void)clientPwnedDfuSuccess;
- (void)clientPwnedDfuFailed;
- (void)clientNotInRecoveryMode;
- (void)clientDownloadProgress:(NSNotification *)notification;
- (void)clientPatchingFirmwares;
- (void)clientPatchingFirmwaresFailed;
- (void)clientNoInternetConnectionAvailable;

@end

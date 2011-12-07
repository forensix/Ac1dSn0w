// -----------------------------------------------------------------------------
//  ASLoggingViewController+Messages.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 23.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

#import "ASLoggingViewController.h"

@interface ASLoggingViewController (Messages)

- (NSString *)waitingForClientMessage;
- (NSString *)clientWasConnectedMessage;
- (NSString *)clientWasDisconnectedMessage:(NSString *)clientName;
- (NSString *)clientWillEnterRecoveryModeMessage;
- (NSString *)clientHasEnteredRecoveryModeMessage;
- (NSString *)clientHasExitedRecoveryModeMessage;
- (NSString *)clientHasEnteredDFUModeMessage;
- (NSString *)clientHasExitedDFUModeMessage;
- (NSString *)clientTetheredBootSuccessMessage;
- (NSString *)clientTetheredBootFailedMessage;
- (NSString *)clientJailbreakSuccessMessage;
- (NSString *)clientJailbreakFailedMessage;
- (NSString *)clientNotConnectedMessage;
- (NSString *)clientNotInDfuModeMessage;
- (NSString *)clientIncompatibleMessage;
- (NSString *)clientPwnedDfuSuccessMessage;
- (NSString *)clientPwnedDfuFailedMessage;
- (NSString *)clientNotInRecoveryModeMessage;
- (NSString *)clientDownloadProgressMessage:(NSString *)string;
- (NSString *)patchingFirmwaresMessage;
- (NSString *)patchingFirmwaresFailedMessage;
- (NSString *)noInternetConnectionAvailableMessage;

@end

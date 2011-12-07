// -----------------------------------------------------------------------------
//  ASLoggingViewControllwe.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASLoggingViewController.h"
#import "ASLoggingViewController+Messages.h"
#import "ASClientDeviceNotificationCenter.h"

@interface ASLoggingViewController ()

- (void)setupInitialValues;
- (void)cleanupInitialValues;

- (void)registerAtNotificationCenter;
- (void)deregisterFromNotificationCenter;

@end

@implementation ASLoggingViewController

// -----------------------------------------------------------------------------
#pragma mark Injection
// -----------------------------------------------------------------------------

@synthesize textView = _textView;

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
    RELEASE_SAFELY(_textView);
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
    NSString *string = [self waitingForClientMessage];
    [self.textView setFont:[NSFont systemFontOfSize:10]];
    [self.textView setTextColor:[NSColor whiteColor]];
    [self.textView setString:string];
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
#pragma mark Target-Action
// -----------------------------------------------------------------------------

- (IBAction)clearConsoleAction:(id)sender
{
    [self.textView setString:@""];
}


// -----------------------------------------------------------------------------
#pragma mark ASClientDeviceDataSource
// -----------------------------------------------------------------------------

- (void)updateTextView
{
    // Always scroll to bottom.
    [self.textView scrollRangeToVisible:
     NSMakeRange([[self.textView textStorage] length], 0)];
}

- (void)clientWasConnected
{
    NSString *string = [self clientWasConnectedMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientWasDisconnected:(NSNotification *)notification
{
    NSString *clientName = (NSString *)[notification object];
    NSString *string = [self clientWasDisconnectedMessage:clientName];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientWillEnterRecoveryMode
{
    NSString *string = [self clientWillEnterRecoveryModeMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientHasEnteredRecoveryMode
{
    NSString *string = [self clientHasEnteredRecoveryModeMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientHasExitedRecoveryMode
{
    NSString *string = [self clientHasExitedRecoveryModeMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientHasEnteredDFUMode
{
    NSString *string = [self clientHasEnteredDFUModeMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientHasExitedDFUMode
{
    NSString *string = [self clientHasExitedDFUModeMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientTetheredBootSuccess
{
    NSString *string = [self clientTetheredBootSuccessMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientTetheredBootFailed
{
    NSString *string = [self clientTetheredBootFailedMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientJailbreakSuccess
{
    NSString *string = [self clientJailbreakSuccessMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientJailbreakFailed
{
    NSString *string = [self clientJailbreakFailedMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientNotConnected
{
    NSString *string = [self clientNotConnectedMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientNotInDfuMode
{
    NSString *string = [self clientNotInDfuModeMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientIncompatible
{
    NSString *string = [self clientIncompatibleMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientPwnedDfuSuccess
{
    NSString *string = [self clientPwnedDfuSuccessMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientPwnedDfuFailed
{
    NSString *string = [self clientPwnedDfuFailedMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientNotInRecoveryMode
{
    NSString *string = [self clientNotInRecoveryModeMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)updateTextViewOnMainThreadWithObject:(NSString *)object
{
    [[[self.textView textStorage] mutableString] appendString:object];
    [self updateTextView];
}


- (void)clientDownloadProgress:(NSNotification *)notification
{
    NSString *message = (NSString *)[notification object];
    NSString *string = [self clientDownloadProgressMessage:message];
    [self performSelectorOnMainThread:@selector(updateTextViewOnMainThreadWithObject:)
                           withObject:string waitUntilDone:NO];
}

- (void)clientPatchingFirmwares
{
    NSString *string = [self patchingFirmwaresMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}


- (void)clientPatchingFirmwaresFailed
{
    NSString *string = [self patchingFirmwaresFailedMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}

- (void)clientNoInternetConnectionAvailable
{
    NSString *string = [self noInternetConnectionAvailableMessage];
    [[[self.textView textStorage] mutableString] appendString:string];
    [self updateTextView];
}



@end

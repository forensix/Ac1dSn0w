// -----------------------------------------------------------------------------
//  ASJailbreakViewController.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 24.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "libAc1d.h"

#import "ASJailbreakViewController.h"
#import "ASClientDevice.h"
#import "ASClientDeviceNotifications.h"
#import "ASClientWatchdog.h"
#import "ASPatcher.h"
#import "ASClientConfiguration.h"
#import "ASCacheManager.h"
#import <SystemConfiguration/SCNetwork.h>
#import "YRKSpinningProgressIndicator.h"

@interface ASJailbreakViewController ()

- (void)setupInitialValues;
- (void)cleanupInitialValues;

- (void)bootTethered;
- (void)jailbreak;
- (void)pwnedDfu;

@end

@implementation ASJailbreakViewController

@synthesize indicatorLabel      = _indicatorLabel;
@synthesize indicator           = _indicator;
@synthesize jailbreakButton     = _jailbreakButton;
@synthesize bootTetheredButton  = _bootTetheredButton;
@synthesize pwnedDfuButton      = _pwnedDfuButton;
@synthesize exitRecoveryButton  = _exitRecoveryButton;
@synthesize ipTextField         = _ipTextField;
@synthesize consolePanel        = _consolePanel;
@synthesize assistantPanel      = _assistantPanel;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_indicator setColor:[NSColor whiteColor]];
    [_assistantPanel setAlphaValue:.0f];
	[_consolePanel setAlphaValue:.0f];
}


- (void)dealloc
{
    [self cleanupInitialValues];
    [super dealloc];
}


- (void)cleanupInitialValues
{
    RELEASE_SAFELY(_indicatorLabel);
    RELEASE_SAFELY(_indicator);
    RELEASE_SAFELY(_defaultCenter);
    RELEASE_SAFELY(_jailbreakButton);
    RELEASE_SAFELY(_bootTetheredButton);
    RELEASE_SAFELY(_pwnedDfuButton);
    RELEASE_SAFELY(_exitRecoveryButton);
    RELEASE_SAFELY(_ipTextField);
    RELEASE_SAFELY(_consolePanel);
    RELEASE_SAFELY(_assistantPanel);
}


- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self setupInitialValues];
    }
    
    return self;
}


- (void)setupInitialValues
{
    _defaultCenter
    = [[NSNotificationCenter defaultCenter] retain];
    
    _tetheredBootInProgress = NO;
}


// -----------------------------------------------------------------------------
#pragma mark Show/Hide
// -----------------------------------------------------------------------------

- (void)showIndicator
{
    [self.indicatorLabel setHidden:NO];
    [self.indicator startAnimation:self];
}


- (void)hideIndicator
{
    [self.indicatorLabel setHidden:YES];
    [self.indicator stopAnimation:self];
}


- (void)disableButtons
{
    [self.jailbreakButton setEnabled:NO];
    [self.bootTetheredButton setEnabled:NO];
    [self.pwnedDfuButton setEnabled:NO];
    [self.exitRecoveryButton setEnabled:NO];
}


- (void)enableButtons
{
    [self.jailbreakButton setEnabled:YES];
    [self.bootTetheredButton setEnabled:YES];
    [self.pwnedDfuButton setEnabled:YES];
    [self.exitRecoveryButton setEnabled:YES];    
}

- (void)showConsole
{
    [self.consolePanel setAlphaValue:1.0f];
}


- (void)hideConsole
{
    [self.consolePanel setAlphaValue:.0f];
}

- (void)showAssistant
{
    [self.assistantPanel setAlphaValue:1.0f];
}


- (void)hideAssistant
{
    [self.assistantPanel setAlphaValue:.0f];
}


- (void)enableGuiComponents
{
    [self hideIndicator];
    [self enableButtons];
}


// -----------------------------------------------------------------------------
#pragma mark Notifications
// -----------------------------------------------------------------------------

- (void)postThatTetheredBootFailedNotification
{
    [_defaultCenter
     postNotificationName:ASTetheredBootFailedNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatTetheredBootSuccessNotification
{
    [_defaultCenter
     postNotificationName:ASTetheredBootSuccessNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatJailbreakFailedNotification
{
    [_defaultCenter
     postNotificationName:ASJailbreakFailedNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatJailbreakSuccessNotification
{
    [_defaultCenter
     postNotificationName:ASJailbreakSuccessNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}

- (void)postThatDeviceNotConnectedNotification
{
    [_defaultCenter
     postNotificationName:ASClientNotConnectedNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatDeviceNotInDfuModeNotification
{
    [_defaultCenter
     postNotificationName:ASClientNotInDfuModeNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatClientIsIncompatibleNotification
{
    [_defaultCenter
     postNotificationName:ASClientIncompatibleNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatPwnedDfuSuccessNotification
{
    [_defaultCenter
     postNotificationName:ASClientPwnedDfuModeSuccessNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatPwnedDfuFailedNotification
{
    [_defaultCenter
     postNotificationName:ASClientPwnedDfuModeFailedNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatDeviceNotInRecoveryModeNotification
{
    [_defaultCenter
     postNotificationName:ASClientNotInRecoveryModeNotification
     object:nil];
    [self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (void)postThatPatchingFirmwaresNotification
{
    [_defaultCenter
     postNotificationName:ASClientPatchingFirmwaresNotification
     object:nil];
}


- (void)postThatPatchingFirmwaresFailedNotification
{
    [_defaultCenter
     postNotificationName:ASClientPatchingFirmwaresFailedNotification
     object:nil];
}

- (void)postThatNoInternetConnectionAvailableNotification
{
    [_defaultCenter
     postNotificationName:ASClientNoInternetConnectionAvailableNotification
     object:nil];
}


// -----------------------------------------------------------------------------
#pragma mark Target-Action
// -----------------------------------------------------------------------------

- (IBAction)enterRecoveryAction:(id)sender
{
    [ASClientDevice enterRecoveryMode];
}


- (IBAction)exitRecoveryAction:(id)sender
{
    [self disableButtons];
    [self showIndicator];
    
    ASClientWatchdog *watchdog
    = [ASClientWatchdog sharedWatchdog];
    
    if (_tetheredBootInProgress)
        return;
    if (![watchdog clientConnected]) {
        [self postThatDeviceNotConnectedNotification];
        return;
    }
    if (![watchdog clientEnteredRecoveryMode]) {
        [self postThatDeviceNotInRecoveryModeNotification];
        return;
    }
    [ASClientDevice exitRecoveryMode];
	[self performSelector:@selector(enableGuiComponents) withObject:nil afterDelay:.62f];
}


- (IBAction)rebootAction:(id)sender
{
    [ASClientDevice reboot];
}


- (IBAction)deactivateAction:(id)sender
{
    [ASClientDevice deactivate];
}


- (IBAction)tetheredBootAction:(id)sender
{
    [self disableButtons];
    [self showIndicator];
    [self bootTethered];
}


- (IBAction)jailbreakAction:(id)sender
{
    [self disableButtons];
    [self showIndicator];
    [self jailbreak];
}


- (IBAction)pwnedDfuAction:(id)sender
{
    [self disableButtons];
    [self showIndicator];
    [self pwnedDfu];
}


- (IBAction)showConsoleAction:(id)sender
{
    NSButton *checkboxButton
    = (NSButton *)sender;
    
    if ([checkboxButton state] == NSOnState)
    {
        [self showConsole];
    }
    else
    {
        [self hideConsole];
    }
}

- (IBAction)showAssistantAction:(id)sender
{
    NSButton *checkboxButton
    = (NSButton *)sender;
    
    if ([checkboxButton state] == NSOnState)
    {
        [self showAssistant];
    }
    else
    {
        [self hideAssistant];
    }
}


- (IBAction)remoteContextAction:(id)sender
{
    NSButton *checkboxButton
    = (NSButton *)sender;
    
    if ([checkboxButton state] == NSOnState)
    {
        [self.ipTextField setEnabled:YES];
    }
    else
    {
        [self.ipTextField setEnabled:NO];
    }
}


- (BOOL)useRemoteDevice
{
    return [self.ipTextField isEnabled];
}


- (BOOL)initialCheckSuccess
{
    ASClientWatchdog *watchdog
    = [ASClientWatchdog sharedWatchdog];
    
    if (_tetheredBootInProgress)
        return NO;
	if (![watchdog clientConnected]) {
		[self postThatDeviceNotConnectedNotification];
		return NO;
	}
	if (![watchdog clientEnteredDFUMode]) {
		[self postThatDeviceNotInDfuModeNotification];
		return NO;
	}
    
    return YES;
}


- (void)bootTethered
{
    BOOL initialCheckSuccess = [self initialCheckSuccess];
    if (!initialCheckSuccess)
        return;
    _tetheredBootInProgress = YES;
    SEL selector = @selector(bootTetheredThread);
    [self performSelectorInBackground:selector withObject:nil];    
}


- (void)jailbreak
{
    BOOL initialCheckSuccess = [self initialCheckSuccess];
    if (!initialCheckSuccess)
        return;
    _tetheredBootInProgress = YES;
    SEL selector = @selector(jailbreakThread);
    [self performSelectorInBackground:selector withObject:nil];
}


- (void)pwnedDfu
{
    BOOL initialCheckSuccess = [self initialCheckSuccess];
    if (!initialCheckSuccess)
        return;
    _tetheredBootInProgress = YES;
    SEL selector = @selector(pwnedDfuThread);
    [self performSelectorInBackground:selector withObject:nil];
}


static int create_client_socket()
{
    int sock = socket(PF_INET, SOCK_STREAM, 0);
    if (sock == -1)
        return -1;
    
    return sock;
}


static int try_connect(int sock, const char *ip, int port)
{
    struct sockaddr_in server;
    int success;
    
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    
    success = inet_aton(ip, &(server.sin_addr));
    if (!success)
        return -1;
    
    return connect(sock,
                   (struct sockaddr *)&server,
                   sizeof server);
}


static int connect_to_server(const char *ip, int port)
{
    int sock = create_client_socket();
    
    if (sock == -1) {
        fprintf(stderr, "Error! Failed to create a client socket: %s\n", ip);
        return -1;
	}
    
    if (try_connect(sock, ip, port) == -1) {
        fprintf(stderr, "Error! Failed to connect to a server at: %s\n", ip);
        return -1;
    }
    
    return sock;
}


- (NSString *)keyForDevice:(ac1d_device_t)device
{
    NSString *key = nil;

    switch (device) {
    case AC1D_D_IPAD1G:
        key = @"k48ap_5.0.1";
        break;
    case AC1D_D_IPHONE4:
        key = @"n90ap_5.0.1";
        break;
    case AC1D_D_IPHONE3GS:
        key = @"n88ap_5.0.1";
        break;
    case AC1D_D_IPOD4G:
        key = @"n81ap_5.0.1";
        break;
    default:
        break;
    }
    
    return key;
}

-(BOOL)isInternetAvailable
{
    BOOL retval = NO;
    const char *hostName = [@"google.com" cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkConnectionFlags flags = 0;
    
    if (SCNetworkCheckReachabilityByName(hostName, &flags) && flags > 0) 
    {
        if (flags == kSCNetworkFlagsReachable)
        {
            retval = YES;
        }
    }
    
    return retval;
}


- (BOOL)internetCheckSuccessForKey:(NSString *)key
{
    ASCacheManager *cacheManager
	= [ASCacheManager sharedCacheManager];
	
    BOOL kernelcacheAlreadyCached
	= [cacheManager wasKernelcacheCachedForKey:key];
    
	BOOL iBECAlreadyCached
	= [cacheManager wasiBECCachedForKey:key];
    
	BOOL iBSSAlreadyCached
	= [cacheManager wasiBSSCachedForKey:key];    
    
    if (!kernelcacheAlreadyCached || !iBECAlreadyCached || !iBSSAlreadyCached)
    {
        BOOL isInternetAvailable = [self isInternetAvailable];
        if (!isInternetAvailable)
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)bootTetheredThread
{
    NSAutoreleasePool *autoreleasePool
    = [[NSAutoreleasePool alloc] init];
    
    ac1d_error_t error = AC1D_E_SUCCESS;
    ac1d_context_t ctx = AC1D_C_LOCAL;
    ac1d_device_t device;
    BOOL compatible = YES;
    BOOL success = YES;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    ac1d_init(ctx, -1, [[mainBundle resourcePath] UTF8String]);
    while ((error = ac1d_is_ready()) != AC1D_E_SUCCESS) {
        sleep(1);
    }
    
    error = ac1d_is_compatible();
    if (error != AC1D_E_SUCCESS) {
        compatible = NO;
        goto exit_fail;
    }

    device = ac1d_connected_device();
    NSString *key = [self keyForDevice:device];

    if (![self internetCheckSuccessForKey:key])
    {
        [self performSelectorOnMainThread:@selector(postThatNoInternetConnectionAvailableNotification)
                               withObject:nil waitUntilDone:NO];
        goto exit_fail;
    }
    
    [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresNotification)
                           withObject:nil waitUntilDone:YES];
    
    success = [ASPatcher patchKernelcacheForKey:key];
    if (!success) {
        [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresFailedNotification)
                               withObject:nil waitUntilDone:YES];
        goto exit_fail;
    }
    
    success = [ASPatcher patchiBECForKey:key];
    if (!success) {
        [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresFailedNotification)
                               withObject:nil waitUntilDone:YES];
        goto exit_fail;
    }
    
    success = [ASPatcher patchiBSSForKey:key];
    if (!success) {
        [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresFailedNotification)
                               withObject:nil waitUntilDone:YES];
        goto exit_fail;
    }
    
    ASClientConfiguration *clientConfiguration
    = [ASClientConfiguration sharedClientConfiguration];
    
    const char *kernelcache
    = [[clientConfiguration kernelcacheFinalPathForKey:key] UTF8String];
    
    const char *iBEC
    = [[clientConfiguration iBECFinalPathForKey:key] UTF8String];
    
    const char *iBSS
    = [[clientConfiguration iBSSFinalPathForKey:key] UTF8String];
    
    error = ac1d_boot_tethered(kernelcache, iBEC, iBSS);
    if (error != AC1D_E_SUCCESS)
        goto exit_fail;
    
    ac1d_exit();
    _tetheredBootInProgress = NO;
    [self performSelectorOnMainThread:@selector(postThatTetheredBootSuccessNotification)
                           withObject:nil waitUntilDone:YES];
    [autoreleasePool release];
    return;
exit_fail:
    ac1d_exit();
    _tetheredBootInProgress = NO;
    if (compatible)
    {
        [self performSelectorOnMainThread:@selector(postThatTetheredBootFailedNotification)
                               withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(postThatClientIsIncompatibleNotification)
                               withObject:nil waitUntilDone:YES];
    }
    [autoreleasePool release];
}


- (void)jailbreakThread
{
    NSAutoreleasePool *autoreleasePool
    = [[NSAutoreleasePool alloc] init];
    
    ac1d_error_t error = AC1D_E_SUCCESS;
    ac1d_context_t ctx = AC1D_C_LOCAL;
    ac1d_device_t device;
    BOOL success = YES;
    BOOL compatible = YES;
    int sock;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    ac1d_init(ctx, sock, [[mainBundle resourcePath] UTF8String]);
    while ((error = ac1d_is_ready()) != AC1D_E_SUCCESS) {
        sleep(1);
    }
    
    error = ac1d_is_compatible();
    if (error != AC1D_E_SUCCESS) {
        compatible = NO;
        goto exit_fail;
    }
    
    device = ac1d_connected_device();
    NSString *key = [self keyForDevice:device];
    
    if (![self internetCheckSuccessForKey:key])
    {
        [self performSelectorOnMainThread:@selector(postThatNoInternetConnectionAvailableNotification)
                               withObject:nil waitUntilDone:NO];
        goto exit_fail;
    }
    
    [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresNotification)
                           withObject:nil waitUntilDone:YES];
    
    success = [ASPatcher patchKernelcacheForKey:key];
    if (!success) {
        [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresFailedNotification)
                               withObject:nil waitUntilDone:YES];
        goto exit_fail;
    }
    
    success = [ASPatcher patchiBECForKey:key];
    if (!success) {
        [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresFailedNotification)
                               withObject:nil waitUntilDone:YES];
        goto exit_fail;
    }
    
    success = [ASPatcher patchiBSSForKey:key];
    if (!success) {
        [self performSelectorOnMainThread:@selector(postThatPatchingFirmwaresFailedNotification)
                               withObject:nil waitUntilDone:YES];
        goto exit_fail;
    }

    ASClientConfiguration *clientConfiguration
    = [ASClientConfiguration sharedClientConfiguration];
    
    const char *kernelcache
    = [[clientConfiguration kernelcacheFinalPathForKey:key] UTF8String];
    
    const char *iBEC
    = [[clientConfiguration iBECFinalPathForKey:key] UTF8String];
    
    const char *iBSS
    = [[clientConfiguration iBSSFinalPathForKey:key] UTF8String];

    error = ac1d_jailbreak(kernelcache, iBEC, iBSS);
    if (error != AC1D_E_SUCCESS)
        goto exit_fail;
    
    ac1d_exit();
    _tetheredBootInProgress = NO;
    [self performSelectorOnMainThread:@selector(postThatJailbreakSuccessNotification)
                           withObject:nil waitUntilDone:YES];
    [autoreleasePool release];
    return;
exit_fail:
    ac1d_exit();
    _tetheredBootInProgress = NO;
    if (compatible)
    {
        [self performSelectorOnMainThread:@selector(postThatJailbreakFailedNotification)
                               withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(postThatClientIsIncompatibleNotification)
                               withObject:nil waitUntilDone:YES];
    }

    [autoreleasePool release];
}


- (void)pwnedDfuThread
{
    NSAutoreleasePool *autoreleasePool
    = [[NSAutoreleasePool alloc] init];
    
    ac1d_error_t error = AC1D_E_SUCCESS;
    ac1d_context_t ctx = AC1D_C_LOCAL;
    BOOL compatible = YES;
    NSBundle *mainBundle = [NSBundle mainBundle];

    ac1d_init(ctx, -1, [[mainBundle resourcePath] UTF8String]);
    
    while ((error = ac1d_is_ready()) != AC1D_E_SUCCESS) {
        sleep(1);
    }
    
    error = ac1d_is_compatible();
    if (error != AC1D_E_SUCCESS) {
        compatible = NO;
        goto exit_fail;
    }
    
    error = ac1d_enter_pwned_dfu();
    if (error != AC1D_E_SUCCESS)
        goto exit_fail;
    
    ac1d_exit();
    _tetheredBootInProgress = NO;
    [self performSelectorOnMainThread:@selector(postThatPwnedDfuSuccessNotification)
                           withObject:nil waitUntilDone:YES];
    [autoreleasePool release];
    return;
exit_fail:
    ac1d_exit();
    _tetheredBootInProgress = NO;
    if (compatible)
    {
        [self performSelectorOnMainThread:@selector(postThatPwnedDfuFailedNotification)
                               withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(postThatClientIsIncompatibleNotification)
                               withObject:nil waitUntilDone:YES];
    }
    [autoreleasePool release];
}


@end

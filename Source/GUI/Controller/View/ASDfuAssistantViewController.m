// -----------------------------------------------------------------------------
//  ASDfuAssistantViewController.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASDfuAssistantViewController.h"
#import "ASClientDeviceNotificationCenter.h"
#import "ASClientWatchdog.h"

@interface ASDfuAssistantViewController()

- (void)setupInitialValues;
- (void)cleanupInitialValues;
- (void)fireTimer;

- (void)registerAtNotificationCenter;
- (void)deregisterFromNotificationCenter;

@end

@implementation ASDfuAssistantViewController

@synthesize textView            = _textView;
@synthesize startButton         = _startButton;
@synthesize resetButton         = _resetButton;
@synthesize countdownTextView   = _countdownTextView;

- (void)dealloc
{
    [self deregisterFromNotificationCenter];
    [self cleanupInitialValues];
    [super dealloc];
}


- (void)cleanupInitialValues
{
    [_timer invalidate];
    _timer = nil;
    RELEASE_SAFELY(_textView);
    RELEASE_SAFELY(_startButton);
    RELEASE_SAFELY(_resetButton);
    RELEASE_SAFELY(_countdownTextView);
}


- (id)init
{
    if ((self = [super init]) != nil)
    {
        [self registerAtNotificationCenter];
    }
    
    return self;
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



- (NSString *)initialText
{
    return @"NOTE:\n\nIn order to jailbreak your device, you need to put it into DFU Mode.  The same applies if you want to boot tethered or enter pwned DFU.\n\nThe DFU Mode Assistant helps you to put your device into DFU Mode.  Just click 'Start'  if your device is both plugged in and turned off.";
}


- (NSString *)phase1Text
{
    return @"\n\n\n\t\t\t\t      Hold down the POWER BUTTON...";
}


- (NSString *)phase2Text
{
    return @"\n\n\n\t\t\t\t     Also hold down the HOME BUTTON...";
}


- (NSString *)phase3Text
{
    return @"\n\n\n\t\tRelease the POWER BUTTON but keep holding the HOME BUTTON...";
}

- (NSString *)dfuModeText
{
    return @"\n\n\n\t\t\t\t\tYour device is now in DFU Mode.";
}


- (NSString *)alreadyInDfuModeText
{
    return @"\n\n\n\t\t\t\t\tYour device is alredy in DFU Mode.";
}


- (void)setupInitialValues
{
    [self.textView setFont:[NSFont boldSystemFontOfSize:10]];
    [self.textView setTextColor:[NSColor whiteColor]];
    [self.textView setString:[self initialText]];
    [self.countdownTextView setFont:[NSFont boldSystemFontOfSize:32]];
    [self.countdownTextView setTextColor:[NSColor whiteColor]];
}


- (void)awakeFromNib
{
    [self setupInitialValues];
}


- (void)updateSeconds
{
    if (_seconds == 16)
    {
        [self.textView setString:[self phase3Text]];
    }
    else if (_seconds == 11 && _currentState != ASDfuAssistantStatePhase3)
    {
        [self.textView setString:[self phase2Text]];
    }
    _seconds--;
    
    NSString *formatString = @"    %d";
    
    if (_seconds > 9)
    {
        formatString = @"   %d";
    }
    
    NSString *secondsAsString = [NSString stringWithFormat:formatString, _seconds];
    [self.countdownTextView setString:secondsAsString];
    
    if (_seconds == 1) {
        _currentState++;
        if (_currentState == ASDfuAssistantStatePhase2) {
            _seconds = 11;
        }
        else if (_currentState == ASDfuAssistantStatePhase3) {
            _seconds = 16;
        } else if (_currentState > ASDfuAssistantStatePhase3) {
            [_timer invalidate];
            _timer = nil;
            return;
        }
        
        [self fireTimer];
    }
}


- (void)fireTimer
{
    [_timer invalidate];
    _timer = nil;
    
    _timer =
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateSeconds)
                                   userInfo:nil
                                    repeats:YES];
}


- (IBAction)resetAction:(id)sender
{
    [_timer invalidate];
    _timer = nil;
    [self.startButton setHidden:NO];
    [self.resetButton setHidden:YES];
    [self.countdownTextView setHidden:YES];
    [self.textView setFont:[NSFont boldSystemFontOfSize:10]];
    [self.textView setString:@""];
    [self.textView setString:[self initialText]];
}


- (IBAction)startAction:(id)sender
{
    ASClientWatchdog *watchdog = [ASClientWatchdog sharedWatchdog];
    
    BOOL alreadyInDfuMode = [watchdog clientEnteredDFUMode];
    if (alreadyInDfuMode)
    {
        [self.textView setString:[self alreadyInDfuModeText]];
        return;
    }
    
    _seconds = 4;
    _currentState = ASDfuAssistantStatePhase1;
    [self.startButton setHidden:YES];
    [self.resetButton setHidden:NO];
    [self.countdownTextView setHidden:NO];
    [self.countdownTextView setString:@"    4"];
    [self.textView setFont:[NSFont boldSystemFontOfSize:10]];
    [self.textView setString:@""];
    [self.textView setString:[self phase1Text]];
    [self fireTimer];
    
}


- (void)clientHasEnteredDFUMode
{
    [self.textView setString:[self dfuModeText]];
    [self.countdownTextView setHidden:YES];
}


@end

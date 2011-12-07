// -----------------------------------------------------------------------------
//  ASJailbreakViewController.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 24.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

@class YRKSpinningProgressIndicator;

@interface ASJailbreakViewController : NSObject
{
    NSTextField                  *_indicatorLabel;
    YRKSpinningProgressIndicator *_indicator;
    NSNotificationCenter         *_defaultCenter;
    BOOL                          _tetheredBootInProgress;
    NSButton                     *_jailbreakButton;
    NSButton                     *_bootTetheredButton;
    NSButton                     *_pwnedDfuButton;
    NSButton                     *_exitRecoveryButton;
    NSTextField                  *_ipTextField;
    // TODO: Wrong place!
    NSPanel                      *_consolePanel;
    NSPanel                      *_assistantPanel;
}

@property (retain) IBOutlet NSTextField *indicatorLabel;
@property (retain) IBOutlet YRKSpinningProgressIndicator *indicator;
@property (retain) IBOutlet NSButton *jailbreakButton;
@property (retain) IBOutlet NSButton *bootTetheredButton;
@property (retain) IBOutlet NSButton *pwnedDfuButton;
@property (retain) IBOutlet NSButton *exitRecoveryButton;
@property (retain) IBOutlet NSTextField *ipTextField;
@property (retain) IBOutlet NSPanel *consolePanel;
@property (retain) IBOutlet NSPanel *assistantPanel;

- (IBAction)enterRecoveryAction:(id)sender;
- (IBAction)exitRecoveryAction:(id)sender;
- (IBAction)rebootAction:(id)sender;
- (IBAction)deactivateAction:(id)sender;
- (IBAction)tetheredBootAction:(id)sender;
- (IBAction)jailbreakAction:(id)sender;
- (IBAction)pwnedDfuAction:(id)sender;
- (IBAction)showConsoleAction:(id)sender;
- (IBAction)showAssistantAction:(id)sender;
- (IBAction)remoteContextAction:(id)sender;

@end

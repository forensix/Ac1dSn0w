// -----------------------------------------------------------------------------
//  ASDfuAssistantViewController.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "ASClientDeviceDataSource.h"

typedef enum {
    ASDfuAssistantStatePhase1,
    ASDfuAssistantStatePhase2,
    ASDfuAssistantStatePhase3
} ASDfuAssistantState;

@interface ASDfuAssistantViewController : NSObject
<
    ASClientDeviceDataSource
>
{
    NSTextView          *_textView;
    NSButton            *_startButton;
    NSButton            *_resetButton;
    NSTextView          *_countdownTextView;
@private
    NSTimer             *_timer;
    ASDfuAssistantState  _currentState;
    NSInteger            _seconds;
}

@property (retain) IBOutlet NSTextView *textView;
@property (retain) IBOutlet NSButton *startButton;
@property (retain) IBOutlet NSButton *resetButton;
@property (retain) IBOutlet NSTextView *countdownTextView;

- (IBAction)startAction:(id)sender;
- (IBAction)resetAction:(id)sender;

@end

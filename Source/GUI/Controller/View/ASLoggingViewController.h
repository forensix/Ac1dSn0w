// -----------------------------------------------------------------------------
//  ASLoggingViewController.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

#import "ASClientDeviceDataSource.h"

@interface ASLoggingViewController : NSObject
<
    ASClientDeviceDataSource
>
{
    NSTextView *_textView;
}

@property (retain) IBOutlet NSTextView *textView;

- (IBAction)clearConsoleAction:(id)sender;

@end

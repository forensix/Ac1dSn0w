// -----------------------------------------------------------------------------
//  ASHelper.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 23.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

@interface ASHelper : NSObject

+ (void)logError:(NSString *)error forClass:(id)class withSelector:(SEL)selector;

@end

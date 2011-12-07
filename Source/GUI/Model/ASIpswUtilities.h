// -----------------------------------------------------------------------------
//  ASIpswUtilities.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

@interface ASIpswUtilities : NSObject

+ (NSString *)sha1HashForIpswAtPath:(NSString *)ipswPath;
+ (BOOL)untetheredJailbreakPossibleForFirmware:(NSString *)firmware;

@end

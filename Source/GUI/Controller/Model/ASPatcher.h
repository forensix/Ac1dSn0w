// -----------------------------------------------------------------------------
//  ASPatcher.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 03.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface ASPatcher : NSObject

+ (BOOL)patchKernelcacheForKey:(NSString *)key;
+ (BOOL)patchiBECForKey:(NSString *)key;
+ (BOOL)patchiBSSForKey:(NSString *)key;

@end

// -----------------------------------------------------------------------------
//  ASHelper.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 23.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASHelper.h"

@implementation ASHelper

+ (void)logError:(NSString *)error forClass:(id)class withSelector:(SEL)selector
{
    NSLog(@"%@:%@ - %@", error,
          NSStringFromClass([class class]),
          NSStringFromSelector(selector));    
}

@end

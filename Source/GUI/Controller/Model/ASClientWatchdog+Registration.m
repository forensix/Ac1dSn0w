// -----------------------------------------------------------------------------
//  ASClientWatchdog+Registration.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 23.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASClientWatchdog+Registration.h"
#import "ASClientDevice.h"
#import "ASHelper.h"

@implementation ASClientWatchdog (Registration)

- (void)registerClient:(am_device *)client
{
    NSString *key = (NSString *)AMDeviceCopyDeviceIdentifier(client);
    NSString *object = [ASClientDevice name];
    if (!key || !object)
    {
        [ASHelper logError:@"Unable to register client"
                  forClass:[self class]
              withSelector:_cmd];
        return;
    }
    [_clientName setObject:object forKey:key];
}


- (void)deregisterClient:(am_device *)client
{
    NSString *key = (NSString *)AMDeviceCopyDeviceIdentifier(client);
    if (!key || ![_clientName objectForKey:key])
    {
        [ASHelper logError:@"Unable to deregister client"
                  forClass:[self class]
              withSelector:_cmd];
        return;
    }
    [_clientName removeObjectForKey:key];
}


- (NSString *)nameForClient:(am_device *)client
{
    NSString *key = (NSString *)AMDeviceCopyDeviceIdentifier(client);
    if (!key || ![_clientName objectForKey:key])
    {
        [ASHelper logError:@"Unable to get client name"
                  forClass:[self class]
              withSelector:_cmd];
        return nil;
    }
    return (NSString *)[_clientName objectForKey:key];
}


@end

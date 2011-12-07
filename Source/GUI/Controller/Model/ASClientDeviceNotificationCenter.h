// -----------------------------------------------------------------------------
//  ASClientDeviceNotificationCenter.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 21.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

@interface ASClientDeviceNotificationCenter : NSObject
{
@private
    NSMutableDictionary *_observers;
    NSMutableDictionary *_observerObjects;
    NSDictionary        *_notificationInfo;
}

+ (ASClientDeviceNotificationCenter *)sharedCenter;

- (void)registerObserver:(NSObject *)observer name:(NSString *)name object:(id)object;
- (void)deregisterObserver:(NSObject *)observer name:(NSString *)name
                    object:(id)object;
@end

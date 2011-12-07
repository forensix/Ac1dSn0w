// -----------------------------------------------------------------------------
//  ASClientDeviceNotificationCenter.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 21.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASClientDeviceNotificationCenter.h"
#import "ASClientDeviceNotifications.h"
#import "ASClientDeviceDataSource.h"
#import "ASHelper.h"

@interface ASClientDeviceNotificationCenter ()

- (void)setupInitialValues;
- (void)cleanupInitialValues;

@end

@implementation ASClientDeviceNotificationCenter


- (void)dealloc
{
    [self cleanupInitialValues];
    [super dealloc];
}


- (void)cleanupInitialValues
{
    RELEASE_SAFELY(_observers);
    RELEASE_SAFELY(_observerObjects);
}


- (id)init
{
    if (nil != (self = [super init]))
    {
        [self setupInitialValues];
    }
    
    return self;
}


- (NSArray *)notificationNames
{
    return
    [NSArray arrayWithObjects:
     /* ASClientDeviceNotifications */
     ASClientDeviceConnectedNotification,
     ASClientDeviceDisconnectedNotification,
     ASClientDeviceConnectionFailedNotification,
     ASClientDeviceEnteredDFUModeNotification,
     ASClientDeviceExitedDFUModeNotification,
     ASClientDeviceWillEnterRecoveryModeNotification,
     ASClientDeviceEnteredRecoveryModeNotification,
     ASClientDeviceExitedRecoveryModeNotification,
     ASTetheredBootSuccessNotification,
     ASTetheredBootFailedNotification,
     ASJailbreakSuccessNotification,
     ASJailbreakFailedNotification,
     ASClientNotConnectedNotification,
     ASClientNotInDfuModeNotification,
     ASClientIncompatibleNotification,
     ASClientPwnedDfuModeSuccessNotification,
     ASClientPwnedDfuModeFailedNotification,
     ASClientNotInRecoveryModeNotification,
     ASClientDownloadProgressNotification,
     ASClientPatchingFirmwaresNotification,
     ASClientPatchingFirmwaresFailedNotification,
     ASClientNoInternetConnectionAvailableNotification,
     nil];
}


- (NSArray *)observerSelectors
{
    return
    [NSArray arrayWithObjects:
     /* ASClientDeviceDataSource */
     [NSValue value:&@selector(clientWasConnected) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientWasDisconnected:) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientConnectionFailed) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientHasEnteredDFUMode) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientHasExitedDFUMode) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientWillEnterRecoveryMode) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientHasEnteredRecoveryMode) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientHasExitedRecoveryMode) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientTetheredBootSuccess) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientTetheredBootFailed) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientJailbreakSuccess) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientJailbreakFailed) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientNotConnected) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientNotInDfuMode) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientIncompatible) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientPwnedDfuSuccess) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientPwnedDfuFailed) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientNotInRecoveryMode) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientDownloadProgress:) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientPatchingFirmwares) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientPatchingFirmwaresFailed) withObjCType:@encode(SEL)],
     [NSValue value:&@selector(clientNoInternetConnectionAvailable) withObjCType:@encode(SEL)],
     nil];
}


- (NSDictionary *)newNotificationInfo
{
    NSArray *notificationNames = [self notificationNames];
    NSArray *observerSelectors = [self observerSelectors];
    
    return
    [[NSDictionary dictionaryWithObjects:observerSelectors
                                 forKeys:notificationNames] retain];
}


- (void)setupInitialValues
{
    _observers = [[NSMutableDictionary alloc] initWithCapacity:20];;
    _observerObjects = [[NSMutableDictionary alloc] initWithCapacity:20];
    _notificationInfo = [self newNotificationInfo];
}


+ (ASClientDeviceNotificationCenter *)sharedCenter
{
    static ASClientDeviceNotificationCenter *sharedInstance = nil;
    
    if (nil == sharedInstance)
    {
        sharedInstance = [[super alloc] init];
    }
    
    return sharedInstance;
}
+ (id)alloc                         { return nil; }
- (id)copyWithZone:(NSZone *)zone   { return self; }
- (id)retain                        { return self; }
- (NSUInteger)retainCount           { return NSUIntegerMax; }
- (id)autorelease                   { return self; }


- (void)registerObserver:(NSObject *)observer name:(NSString *)name
                  object:(id)object
{
    if (!observer || !name)
    {
        [ASHelper logError:@"Registration failed (Wrong arguments)."
                  forClass:[self class]
              withSelector:_cmd];
        return;
    }
    
    if (![observer conformsToProtocol:@protocol(ASClientDeviceDataSource)])
    {
        [ASHelper logError:@"Registration failed (Not conform to Protocol)."
                  forClass:[self class]
              withSelector:_cmd];
        return;
    }
    
    [_observers setObject:observer forKey:name];
    
    if (object)
    {
        [_observerObjects setObject:object forKey:name];
    }
    
    NSNotificationCenter *notificationCenter
    = [NSNotificationCenter defaultCenter];
    
    for (id key in _notificationInfo)
    {
        NSString *notificationName = (NSString *)key;
        NSValue *selectorAsValue
        = [_notificationInfo objectForKey:notificationName];
        
        SEL selector;
        [selectorAsValue getValue:&selector];
        
        if (![observer respondsToSelector:selector])
            continue;
        
        [notificationCenter
         addObserver:observer
         selector:selector
         name:notificationName
         object:object];
    }
}


- (void)deregisterObserver:(NSObject *)observer name:(NSString *)name
                    object:(id)object
{
    if (!observer || !name)
    {
        [ASHelper logError:@"Registration failed (Wrong arguments)."
                  forClass:[self class]
              withSelector:_cmd];
        return;
    }

    [_observers removeObjectForKey:name];
    
    if (object)
    {
        [_observerObjects removeObjectForKey:name];
    }
    
    NSNotificationCenter *notificationCenter
    = [NSNotificationCenter defaultCenter];
    
    for (id key in _notificationInfo)
    {
        NSString *notificationName = (NSString *)key;
        
        [notificationCenter
         removeObserver:observer
         name:notificationName
         object:object];
    }
}


@end

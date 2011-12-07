// -----------------------------------------------------------------------------
//  ASDownloadManager.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 02.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface ASDownloadManager : NSObject

+ (ASDownloadManager *)sharedDownloadManager;

- (BOOL)downloadKernelcacheForKey:(NSString *)key;
- (BOOL)downloadiBECForKey:(NSString *)key;
- (BOOL)downloadiBSSForKey:(NSString *)key;

@end

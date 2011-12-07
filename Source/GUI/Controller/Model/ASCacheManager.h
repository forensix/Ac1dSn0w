// -----------------------------------------------------------------------------
//  ASCacheManager.h
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 02.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface ASCacheManager : NSObject

+ (ASCacheManager *)sharedCacheManager;

- (BOOL)wasKernelcacheCachedForKey:(NSString *)key;
- (BOOL)wasiBSSCachedForKey:(NSString *)key;
- (BOOL)wasiBECCachedForKey:(NSString *)key;

- (BOOL)cacheKernelcache:(unsigned char *)data size:(unsigned int)size forKey:(NSString *)key;
- (BOOL)cacheiBEC:(unsigned char *)data size:(unsigned int)size forKey:(NSString *)key;
- (BOOL)cacheiBSS:(unsigned char *)data size:(unsigned int)size forKey:(NSString *)key;

@end

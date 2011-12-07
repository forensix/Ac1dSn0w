// -----------------------------------------------------------------------------
//  ASCacheManager.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 02.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix). 
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASCacheManager.h"
#import "ASClientConfiguration.h"

@implementation ASCacheManager

+ (ASCacheManager *)sharedCacheManager
{
    static ASCacheManager *sharedInstance = nil;
    
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


- (BOOL)wasKernelcacheCachedForKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	return [clientConfiguration doesKernelcacheExistsForKey:key];
}


- (BOOL)wasiBSSCachedForKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	return [clientConfiguration doesiBSSExistsForKey:key];
}


- (BOOL)wasiBECCachedForKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	return [clientConfiguration doesiBECExistsForKey:key];
}


- (BOOL)cacheKernelcache:(unsigned char *)data size:(unsigned int)size
				  forKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	const char *kernelcacheStoragePath
	= [[clientConfiguration kernelcachePathForKey:key] UTF8String];
    
    FILE *fd = fopen(kernelcacheStoragePath, "wb");
	if(!fd)
    {
        return NO;
    }
    
    size_t bytes_written = fwrite(data, 1, size, fd);
	if(bytes_written != size)
    {
        goto fail;
    }
    
    fclose(fd);
	return YES;
fail:	
	fclose(fd);
	return NO;
}


- (BOOL)cacheiBEC:(unsigned char *)data size:(unsigned int)size
		   forKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	const char *iBECStoragePath
	= [[clientConfiguration iBECPathForKey:key] UTF8String];
    
    FILE *fd = fopen(iBECStoragePath, "wb");
	if(!fd)
    {
        return NO;
    }
    
    size_t bytes_written = fwrite(data, 1, size, fd);
	if(bytes_written != size)
    {
        goto fail;
    }
    
    fclose(fd);
	return YES;
fail:	
	fclose(fd);
	return NO;
}


- (BOOL)cacheiBSS:(unsigned char *)data size:(unsigned int)size
		   forKey:(NSString *)key
{	
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	const char *iBSSStoragePath
	= [[clientConfiguration iBSSPathForKey:key] UTF8String];
    
    FILE *fd = fopen(iBSSStoragePath, "wb");
	if(!fd)
    {
        return NO;
    }
    
    size_t bytes_written = fwrite(data, 1, size, fd);
	if(bytes_written != size)
    {
        goto fail;
    }
    
    fclose(fd);	
	return YES;
fail:	
	fclose(fd);
	return NO;
}


@end

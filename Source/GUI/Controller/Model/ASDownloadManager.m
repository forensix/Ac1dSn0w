// -----------------------------------------------------------------------------
//  ASDownloadManager.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 02.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASDownloadManager.h"
#import "ASCacheManager.h"
#import "ASClientConfiguration.h"
#import "ASClientDeviceNotifications.h"

#include "common.h"
#include "partial.h"

char endianness = IS_LITTLE_ENDIAN;
void callback(ZipInfo*, CDFile*, size_t);

typedef enum {
    DL_Type_Kernelcache,
    DL_Type_iBEC,
    DL_Type_iBSS
} DL_Type;

DL_Type dl_type;

@implementation ASDownloadManager

+ (ASDownloadManager *)sharedDownloadManager
{
    static ASDownloadManager *sharedInstance = nil;

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


- (BOOL)downloadKernelcacheForKey:(NSString *)key
{
	ASCacheManager *cacheManager
	= [ASCacheManager sharedCacheManager];
    
	BOOL kernelcacheAlreadyCached
	= [cacheManager wasKernelcacheCachedForKey:key];
	
	if (kernelcacheAlreadyCached)
	{
		return YES;
	}
    
    ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	const char *kernelcacheIpswPath
	= [[clientConfiguration kernelcacheIpswPathForKey:key] UTF8String];
	
	const char *url
	= [[clientConfiguration firmwareDownloadUrlForKey:key isIBSS:NO] UTF8String];


	ZipInfo *info = PartialZipInit(url);
	
	if (!info) {
        printf("Couldn't find ipsw!\n");
        return NO;
    }
	
	CDFile *kernelcache = PartialZipFindFile(info, kernelcacheIpswPath);
    if (!kernelcache) {
        printf("Couldn't find kernelcache!\n");
        return NO;
    }

    dl_type = DL_Type_Kernelcache;
    if(callback != NULL) {
		PartialZipSetProgressCallback(info, callback);
	}
	
	unsigned char* data = PartialZipGetFile(info, kernelcache);
    if (!data) {
        printf("Couldn't get kernelcache data!\n");
        return NO;
    }
	
	BOOL success
	= [cacheManager cacheKernelcache:data size:kernelcache->size forKey:key];
	if (!success)
	{
		printf("Couldn't cache kernelcache!\n");
	}
	
	PartialZipRelease(info);
    free(data);

	return success;
}


- (BOOL)downloadiBECForKey:(NSString *)key
{
	ASCacheManager *cacheManager
	= [ASCacheManager sharedCacheManager];
	
	BOOL iBECAlreadyCached
	= [cacheManager wasiBECCachedForKey:key];
	
	if (iBECAlreadyCached)
	{
		return YES;
	}

    ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];

	const char *iBECIpswPath
	= [[clientConfiguration iBECIpswPathForKey:key] UTF8String];
	
	const char *url
	= [[clientConfiguration firmwareDownloadUrlForKey:key isIBSS:NO] UTF8String];
	
	
	ZipInfo *info = PartialZipInit(url);
	
	if (!info) {
        printf("Couldn't find ipsw!\n");
        return NO;
    }
	
	CDFile *iBEC = PartialZipFindFile(info, iBECIpswPath);
    if (!iBEC) {
        printf("Couldn't find iBEC!\n");
        return NO;
    }
	
    dl_type = DL_Type_iBEC;
    if(callback != NULL) {
		PartialZipSetProgressCallback(info, callback);
	}
	
	unsigned char* data = PartialZipGetFile(info, iBEC);
    if (!data) {
        printf("Couldn't get iBEC data!\n");
        return NO;
    }
	
	BOOL success
	= [cacheManager cacheiBEC:data size:iBEC->size forKey:key];
	if (!success)
	{
		printf("Couldn't cache iBEC!\n");
	}
	
	PartialZipRelease(info);
    free(data);
	
	return success;
}


- (BOOL)downloadiBSSForKey:(NSString *)key
{
	ASCacheManager *cacheManager
	= [ASCacheManager sharedCacheManager];
	
	BOOL iBSSAlreadyCached
	= [cacheManager wasiBSSCachedForKey:key];
	
	if (iBSSAlreadyCached)
	{
		return YES;
	}
    
    ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	const char *iBSSIpswPath
	= [[clientConfiguration iBSSIpswPathForKey:key] UTF8String];
	
	const char *url
	= [[clientConfiguration firmwareDownloadUrlForKey:key isIBSS:YES] UTF8String];
	
	
	ZipInfo *info = PartialZipInit(url);
	
	if (!info) {
        printf("Couldn't find ipsw!\n");
        return NO;
    }
	
	CDFile *iBSS = PartialZipFindFile(info, iBSSIpswPath);
    if (!iBSS) {
        printf("Couldn't find iBSS!\n");
        return NO;
    }
	
    dl_type = DL_Type_iBSS;
    if(callback != NULL) {
		PartialZipSetProgressCallback(info, callback);
	}
	
	unsigned char* data = PartialZipGetFile(info, iBSS);
    if (!data) {
        printf("Couldn't get iBSS data!\n");
        return NO;
    }
	
	BOOL success
	= [cacheManager cacheiBSS:data size:iBSS->size forKey:key];
	if (!success)
	{
		printf("Couldn't cache iBSS!\n");
	}
	
	PartialZipRelease(info);
    free(data);
	
	return success;
}

void callback(ZipInfo* info, CDFile* file, size_t progress)
{
    NSString *object = @"";
    unsigned long percentDone = progress * 100/file->compressedSize;
    
    switch (dl_type) {
    case DL_Type_Kernelcache:
        object = [NSString stringWithFormat:@"Fetching kernelcache (%lu%%)", percentDone];
        break;
    case DL_Type_iBEC:
        object = [NSString stringWithFormat:@"Fetching iBEC (%lu%%)", percentDone];
        break;
    case DL_Type_iBSS:
        object = [NSString stringWithFormat:@"Fetching iBSS (%lu%%)", percentDone];
        break;
    default:
        break;
    }
    
    NSNotificationCenter *defaultCenter
    = [NSNotificationCenter defaultCenter];
    
    [defaultCenter
     postNotificationName:ASClientDownloadProgressNotification
     object:object];
}

@end

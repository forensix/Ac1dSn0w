// -----------------------------------------------------------------------------
//  ASPatcher.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 03.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASPatcher.h"
#import "ASClientConfiguration.h"
#import "ASDownloadManager.h"

#include <stdio.h>

#include "xpwn.h"
#include "bspatch.h"

@implementation ASPatcher

+ (BOOL)patchKernelcacheForKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	ASDownloadManager *downloadManager
	= [ASDownloadManager sharedDownloadManager];
	
    // Just in case...
    [clientConfiguration createCacheFolders];
    
	// Download kernelcache (maybe already cached).
	BOOL success = [downloadManager downloadKernelcacheForKey:key];
	if (!success)
    {
        return NO;
    }
    
	// Decrypt kernelcache
	NSString *kernelcachePath
	= [clientConfiguration kernelcachePathForKey:key];
	
	NSString *kernelcacheDecryptedPath
	= [clientConfiguration kernelcacheDecryptedPathForKey:key];
	
	NSString *kernelcacheIv
	= [clientConfiguration kernelcacheIvForKey:key];
	
	NSString *kernelcacheKey
	= [clientConfiguration kernelcacheKeyForKey:key];
	
	int argc = 7;
	
	const char *argv[] = {
		"xpwntool",
		[kernelcachePath UTF8String],
		[kernelcacheDecryptedPath UTF8String],
		"-iv",[kernelcacheIv UTF8String],
		"-k", [kernelcacheKey UTF8String],
		nil
	};
	
	int retval = xpwn(argc, (char**)argv);
	if (retval != 0)
    {
        return NO;
    }
    
	// Patch kernelcache
	NSString *kernelcachePatch
	= [clientConfiguration kernelcachePatchForKey:key];
	
	NSString *kernelcachePatchedPath
	= [clientConfiguration kernelcachePatchedPathForKey:key];
	
	argc = 4;
	
	const char *argv1[] = {
		"bspatch",
		[kernelcacheDecryptedPath UTF8String],
		[kernelcachePatchedPath UTF8String],
		[kernelcachePatch UTF8String],
		nil
	};
	
	retval = bspatch(argc, (char**)argv1);
    if (retval != 0)
    {
        return NO;
    }
    
	// Encrypt kernelcache
	NSString *kernelcacheFinalPath
	= [clientConfiguration kernelcacheFinalPathForKey:key];
	
	argc = 9;
	
	const char *argv2[] = {
		"xpwntool",
		[kernelcachePatchedPath UTF8String],
		[kernelcacheFinalPath UTF8String],
		"-t", [kernelcachePath UTF8String],
		"-iv",[kernelcacheIv UTF8String],
		"-k", [kernelcacheKey UTF8String],
		nil
	};
	
	retval = xpwn(argc, (char**)argv2);
	if (retval != 0)
    {
        return NO;
    }

	[clientConfiguration kernelcacheCleanupForKey:key];
	
	return YES;
}


+ (BOOL)patchiBECForKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	ASDownloadManager *downloadManager
	= [ASDownloadManager sharedDownloadManager];
    
    // Just in case...
    [clientConfiguration createCacheFolders];
	
	// Download iBEC (maybe already cached).
	BOOL success = [downloadManager downloadiBECForKey:key];
    if (!success)
    {
        return NO;
    }
    
	// Decrypt iBEC
	NSString *iBECPath
	= [clientConfiguration iBECPathForKey:key];
	
	NSString *iBECDecryptedPath
	= [clientConfiguration iBECDecryptedPathForKey:key];
	
	NSString *iBECIv
	= [clientConfiguration iBECIvForKey:key];
	
	NSString *iBECKey
	= [clientConfiguration iBECKeyForKey:key];
	
	int argc = 7;
	
	const char *argv[] = {
		"xpwntool",
		[iBECPath UTF8String],
		[iBECDecryptedPath UTF8String],
		"-iv",[iBECIv UTF8String],
		"-k", [iBECKey UTF8String],
		nil
	};
	
	int retval = xpwn(argc, (char**)argv);
	if (retval != 0)
    {
        return NO;
    }
	
	// Patch iBEC
	NSString *iBECPatch
	= [clientConfiguration iBECPatchForKey:key];
	
	NSString *iBECPatchedPath
	= [clientConfiguration iBECPatchedPathForKey:key];
	
	argc = 4;
	
	const char *argv1[] = {
		"bspatch",
		[iBECDecryptedPath UTF8String],
		[iBECPatchedPath UTF8String],
		[iBECPatch UTF8String],
		nil
	};
	
	retval = bspatch(argc, (char**)argv1);
    if (retval != 0)
    {
        return NO;
    }
	
	// Encrypt iBEC
	NSString *iBECFinalPath
	= [clientConfiguration iBECFinalPathForKey:key];
	
	argc = 9;
	
	const char *argv2[] = {
		"xpwntool",
		[iBECPatchedPath UTF8String],
		[iBECFinalPath UTF8String],
		"-t", [iBECPath UTF8String],
		"-iv",[iBECIv UTF8String],
		"-k", [iBECKey UTF8String],
		nil
	};
	
	retval = xpwn(argc, (char**)argv2);
	if (retval != 0)
    {
        return NO;
    }
	
	[clientConfiguration iBECCleanupForKey:key];
	
	return YES;
}

+ (BOOL)patchiBSSForKey:(NSString *)key
{
	ASClientConfiguration *clientConfiguration
	= [ASClientConfiguration sharedClientConfiguration];
	
	ASDownloadManager *downloadManager
	= [ASDownloadManager sharedDownloadManager];
    
    // Just in case...
    [clientConfiguration createCacheFolders];
	
	// Download iBSS (maybe already cached).
	BOOL success = [downloadManager downloadiBSSForKey:key];
    if (!success)
    {
        return NO;
    }
    
	// Decrypt iBSS
	NSString *iBSSPath
	= [clientConfiguration iBSSPathForKey:key];
	
	NSString *iBSSDecryptedPath
	= [clientConfiguration iBSSDecryptedPathForKey:key];
	
	NSString *iBSSIv
	= [clientConfiguration iBSSIvForKey:key];
	
	NSString *iBSSKey
	= [clientConfiguration iBSSKeyForKey:key];
	
	int argc = 7;
	
	const char *argv[] = {
		"xpwntool",
		[iBSSPath UTF8String],
		[iBSSDecryptedPath UTF8String],
		"-iv",[iBSSIv UTF8String],
		"-k", [iBSSKey UTF8String],
		nil
	};
	
    int retval = xpwn(argc, (char**)argv);
	if (retval != 0)
    {
        return NO;
    }
	
	// Patch iBSS
	NSString *iBSSPatch
	= [clientConfiguration iBSSPatchForKey:key];
	
	NSString *iBSSPatchedPath
	= [clientConfiguration iBSSPatchedPathForKey:key];
	
	argc = 4;
	
	const char *argv1[] = {
		"bspatch",
		[iBSSDecryptedPath UTF8String],
		[iBSSPatchedPath UTF8String],
		[iBSSPatch UTF8String],
		nil
	};
	
	retval = bspatch(argc, (char**)argv1);
    if (retval != 0)
    {
        return NO;
    }
	
	// Encrypt iBSS
	NSString *iBSSFinalPath
	= [clientConfiguration iBSSFinalPathForKey:key];
	
	argc = 9;
	
	const char *argv2[] = {
		"xpwntool",
		[iBSSPatchedPath UTF8String],
		[iBSSFinalPath UTF8String],
		"-t", [iBSSPath UTF8String],
		"-iv",[iBSSIv UTF8String],
		"-k", [iBSSKey UTF8String],
		nil
	};
	
 	retval = xpwn(argc, (char**)argv2);
	if (retval != 0)
    {
        return NO;
    }
	
	[clientConfiguration iBSSCleanupForKey:key];
	
	return YES;
}


@end

// -----------------------------------------------------------------------------
//  ASClientConfiguration.m
//  ac1dtool
//
//  Created by Manuel Gebele (forensix) on 02.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASClientConfiguration.h"

@interface ASClientConfiguration ()

- (void)readPlist;

@end

@implementation ASClientConfiguration

// -----------------------------------------------------------------------------
#pragma mark Dealloc/Init
// -----------------------------------------------------------------------------

- (void)dealloc
{
	RELEASE_SAFELY(_plistAsDictionary);
	[super dealloc];
}


- (id)init
{
	self = [super init];
	if (nil != self)
	{
		[self readPlist];
		[self createCacheFolders];
	}
	
	return self;
}


+ (ASClientConfiguration *)sharedClientConfiguration
{
    static ASClientConfiguration *sharedInstance = nil;
    
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


// -----------------------------------------------------------------------------
#pragma mark General
// -----------------------------------------------------------------------------

- (NSString *)cacheFolderPath
{
	NSString *cacheFolderPath = @"~/Library/Application Support/Ac1dSn0w";
	cacheFolderPath = [cacheFolderPath stringByExpandingTildeInPath];
	return cacheFolderPath;
}


- (NSString *)tmpFolderForKey:(NSString *)key
{
	NSString *tmpFolderPath
	= [NSString stringWithFormat:@"/tmp/%@", key];
	return tmpFolderPath;
}


- (void)createCacheFolderIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	if ([fileManager fileExistsAtPath:cacheFolderPath] == NO)
    {
		[fileManager createDirectoryAtPath:cacheFolderPath
			   withIntermediateDirectories:YES attributes:nil
									 error:nil];
	}
}


// Device related cache folders (eg n90ap_5.0.1 for iPhone 4 gsm iOS 5.0.1)
- (void)createCacheFolderForKey:(NSString *)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	cacheFolderPath
	= [NSString stringWithFormat:@"%@/%@", cacheFolderPath, key];
	
	if ([fileManager fileExistsAtPath:cacheFolderPath] == NO)
    {
		[fileManager createDirectoryAtPath:cacheFolderPath
			   withIntermediateDirectories:YES attributes:nil
									 error:nil];
	}	
}


- (void)createTmpFolderForKey:(NSString *)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *tmpFolderPath = [NSString stringWithFormat:@"/tmp/%@", key];
	
	if ([fileManager fileExistsAtPath:tmpFolderPath] == NO)
    {
		[fileManager createDirectoryAtPath:tmpFolderPath
			   withIntermediateDirectories:YES attributes:nil
									 error:nil];
	}	
}


- (void)createCacheFolders
{
	[self createCacheFolderIfNeeded];
    
	NSArray *keys = [_plistAsDictionary allKeys];
	for (NSString *key in keys)
    {
		[self createCacheFolderForKey:key];
		[self createTmpFolderForKey:key];
	}
}


- (void)readPlist
{
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *plistPath = [mainBundle pathForResource:@"IPSW.plist" ofType:nil];
	_plistAsDictionary = [[NSDictionary dictionaryWithContentsOfFile:plistPath] retain];
}


- (BOOL)doesFileExistsAtPath:(NSString *)path
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:path] == NO) { return NO; }
	return YES;
}

- (NSString *)firmwareDownloadUrlForKey:(NSString *)key isIBSS:(BOOL)isIBSS
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSString *firmwareDownloadUrl = nil;
	
	if (isIBSS)
    {
		firmwareDownloadUrl = [deviceDict objectForKey:@"downloadUrliBSS"];
	}
	else
	{
		firmwareDownloadUrl = [deviceDict objectForKey:@"downloadUrl"];
	}
	
	return firmwareDownloadUrl;
	
}


// -----------------------------------------------------------------------------
#pragma mark Kernelcache
// -----------------------------------------------------------------------------

- (NSString *)kernelcacheIpswPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcacheIpswPath = [kernelcacheDict objectForKey:@"path"];
	
    return kernelcacheIpswPath;
}


- (NSString *)kernelcacheDecryptedPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcacheName = [kernelcacheDict objectForKey:@"decryptedName"];
	NSString *cacheFolderPath = [self cacheFolderPath];

	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, kernelcacheName];

	return kernelcachePath;
}


- (NSString *)kernelcachePatchedPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcacheName = [kernelcacheDict objectForKey:@"patchedName"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, kernelcacheName];
	
	return kernelcachePath;
}

- (NSString *)kernelcacheFinalPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcacheName = [kernelcacheDict objectForKey:@"finalName"];
	NSString *tmpFolderPath = [self tmpFolderForKey:key];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@", tmpFolderPath, kernelcacheName];
	
	return kernelcachePath;
}


- (NSString *)kernelcachePathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcacheName = [kernelcacheDict objectForKey:@"name"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, kernelcacheName];
	
	return kernelcachePath;
}


- (NSString *)kernelcacheIvForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcacheIv = [kernelcacheDict objectForKey:@"iv"];
	
	return kernelcacheIv;
}


- (NSString *)kernelcacheKeyForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcacheKey = [kernelcacheDict objectForKey:@"key"];
	
	return kernelcacheKey;
}


- (NSString *)kernelcachePatchForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *kernelcacheDict = [deviceDict objectForKey:@"kernelcache"];
	NSString *kernelcachePatch = [kernelcacheDict objectForKey:@"patch"];
	NSBundle *mainBundle = [NSBundle mainBundle];
	
	kernelcachePatch
	= [NSString stringWithFormat:@"%@/%@", [mainBundle resourcePath], kernelcachePatch];
	
	return kernelcachePatch;
}

- (BOOL)doesKernelcacheExistsForKey:(NSString *)key
{
	NSString *kernelcachePath = [self kernelcachePathForKey:key];
	
	return [self doesFileExistsAtPath:kernelcachePath];
}


- (void)kernelcacheCleanupForKey:(NSString *)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *kernelcacheDecryptedPath
	= [self kernelcacheDecryptedPathForKey:key];
	
	NSString *kernelcachePatchedPath
	= [self kernelcachePatchedPathForKey:key];
	
	if ([fileManager fileExistsAtPath:kernelcacheDecryptedPath] == YES)
	{
		[fileManager removeItemAtPath:kernelcacheDecryptedPath error:nil];
	}

	if ([fileManager fileExistsAtPath:kernelcachePatchedPath] == YES)
	{
		[fileManager removeItemAtPath:kernelcachePatchedPath error:nil];
	}
}


// -----------------------------------------------------------------------------
#pragma mark iBEC
// -----------------------------------------------------------------------------


- (NSString *)iBECIpswPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECIpswPath = [iBECDict objectForKey:@"path"];
	
	return iBECIpswPath;
}


- (NSString *)iBECDecryptedPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECName = [iBECDict objectForKey:@"decryptedName"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, iBECName];
	
	return kernelcachePath;
}


- (NSString *)iBECPatchedPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECName = [iBECDict objectForKey:@"patchedName"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, iBECName];
	
	return kernelcachePath;
}

- (NSString *)iBECFinalPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECName = [iBECDict objectForKey:@"finalName"];
	NSString *tmpFolderPath = [self tmpFolderForKey:key];
	
	NSString *iBECPath
	= [NSString stringWithFormat:@"%@/%@", tmpFolderPath, iBECName];
	
	return iBECPath;
}


- (NSString *)iBECPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECName = [iBECDict objectForKey:@"name"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, iBECName];
	
	return kernelcachePath;
}


- (NSString *)iBECIvForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECIv = [iBECDict objectForKey:@"iv"];
	
	return iBECIv;
}


- (NSString *)iBECKeyForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECKey = [iBECDict objectForKey:@"key"];
	
	return iBECKey;
}


- (NSString *)iBECPatchForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBECDict = [deviceDict objectForKey:@"iBEC"];
	NSString *iBECPatch = [iBECDict objectForKey:@"patch"];
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	
	iBECPatch
	= [NSString stringWithFormat:@"%@/%@", [mainBundle resourcePath], iBECPatch];

	return iBECPatch;
}


- (BOOL)doesiBECExistsForKey:(NSString *)key
{
	NSString *iBECPath = [self iBECPathForKey:key];
	
	return [self doesFileExistsAtPath:iBECPath];
}


- (void)iBECCleanupForKey:(NSString *)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *iBECDecryptedPath
	= [self iBECDecryptedPathForKey:key];
	
	NSString *iBECPatchedPath
	= [self iBECPatchedPathForKey:key];
	
	if ([fileManager fileExistsAtPath:iBECDecryptedPath] == YES)
	{
		[fileManager removeItemAtPath:iBECDecryptedPath error:nil];
	}
	
	if ([fileManager fileExistsAtPath:iBECPatchedPath] == YES)
	{
		[fileManager removeItemAtPath:iBECPatchedPath error:nil];
	}
}


// -----------------------------------------------------------------------------
#pragma mark iBSS
// -----------------------------------------------------------------------------

- (NSString *)iBSSIpswPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSIpswPath = [iBSSDict objectForKey:@"path"];
	
	return iBSSIpswPath;
}


- (NSString *)iBSSDecryptedPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSName = [iBSSDict objectForKey:@"decryptedName"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, iBSSName];
	
	return kernelcachePath;
}


- (NSString *)iBSSPatchedPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSName = [iBSSDict objectForKey:@"patchedName"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, iBSSName];
	
	return kernelcachePath;
}

- (NSString *)iBSSFinalPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSName = [iBSSDict objectForKey:@"finalName"];
	NSString *tmpFolderPath = [self tmpFolderForKey:key];
	
	NSString *iBSSPath
	= [NSString stringWithFormat:@"%@/%@", tmpFolderPath, iBSSName];
	
	return iBSSPath;
}


- (NSString *)iBSSPathForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSName = [iBSSDict objectForKey:@"name"];
	NSString *cacheFolderPath = [self cacheFolderPath];
	
	NSString *kernelcachePath
	= [NSString stringWithFormat:@"%@/%@/%@", cacheFolderPath, key, iBSSName];
	
	return kernelcachePath;
}


- (NSString *)iBSSIvForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSIv = [iBSSDict objectForKey:@"iv"];
	
	return iBSSIv;
}


- (NSString *)iBSSKeyForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSKey = [iBSSDict objectForKey:@"key"];
	
	return iBSSKey;
}


- (NSString *)iBSSPatchForKey:(NSString *)key
{
	NSDictionary *deviceDict = [_plistAsDictionary objectForKey:key];
	NSDictionary *iBSSDict = [deviceDict objectForKey:@"iBSS"];
	NSString *iBSSPatch = [iBSSDict objectForKey:@"patch"];
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	
	iBSSPatch
	= [NSString stringWithFormat:@"%@/%@", [mainBundle resourcePath], iBSSPatch];
	
	return iBSSPatch;
}


- (BOOL)doesiBSSExistsForKey:(NSString *)key
{
	NSString *iBSSPath = [self iBSSPathForKey:key];
	
	return [self doesFileExistsAtPath:iBSSPath];
}


- (void)iBSSCleanupForKey:(NSString *)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *iBSSDecryptedPath
	= [self iBSSDecryptedPathForKey:key];
	
	NSString *iBSSPatchedPath
	= [self iBSSPatchedPathForKey:key];
	
	if ([fileManager fileExistsAtPath:iBSSDecryptedPath] == YES)
	{
		[fileManager removeItemAtPath:iBSSDecryptedPath error:nil];
	}
	
	if ([fileManager fileExistsAtPath:iBSSPatchedPath] == YES)
	{
		[fileManager removeItemAtPath:iBSSPatchedPath error:nil];
	}
}

@end

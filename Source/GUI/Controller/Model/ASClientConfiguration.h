// -----------------------------------------------------------------------------
//  ASClientConfiguration.h
//  ac1dtool
//
//  Created by Manuel Gebele (forensix) on 02.12.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface ASClientConfiguration : NSObject
{
	NSDictionary *_plistAsDictionary;
}

+ (ASClientConfiguration *)sharedClientConfiguration;

- (NSString *)firmwareDownloadUrlForKey:(NSString *)key isIBSS:(BOOL)isIBSS;

- (NSString *)kernelcacheIpswPathForKey:(NSString *)key;
- (NSString *)kernelcacheDecryptedPathForKey:(NSString *)key;
- (NSString *)kernelcachePatchedPathForKey:(NSString *)key;
- (NSString *)kernelcacheFinalPathForKey:(NSString *)key;
- (NSString *)kernelcachePathForKey:(NSString *)key;
- (NSString *)kernelcacheIvForKey:(NSString *)key;
- (NSString *)kernelcacheKeyForKey:(NSString *)key;
- (NSString *)kernelcachePatchForKey:(NSString *)key;
- (BOOL)doesKernelcacheExistsForKey:(NSString *)key;
- (void)kernelcacheCleanupForKey:(NSString *)key;

- (NSString *)iBECIpswPathForKey:(NSString *)key;
- (NSString *)iBECDecryptedPathForKey:(NSString *)key;
- (NSString *)iBECPatchedPathForKey:(NSString *)key;
- (NSString *)iBECFinalPathForKey:(NSString *)key;
- (NSString *)iBECPathForKey:(NSString *)key;
- (NSString *)iBECIvForKey:(NSString *)key;
- (NSString *)iBECKeyForKey:(NSString *)key;
- (NSString *)iBECPatchForKey:(NSString *)key;
- (BOOL)doesiBECExistsForKey:(NSString *)key;
- (void)iBECCleanupForKey:(NSString *)key;

- (NSString *)iBSSIpswPathForKey:(NSString *)key;
- (NSString *)iBSSDecryptedPathForKey:(NSString *)key;
- (NSString *)iBSSPatchedPathForKey:(NSString *)key;
- (NSString *)iBSSFinalPathForKey:(NSString *)key;
- (NSString *)iBSSPathForKey:(NSString *)key;
- (NSString *)iBSSIvForKey:(NSString *)key;
- (NSString *)iBSSKeyForKey:(NSString *)key;
- (NSString *)iBSSPatchForKey:(NSString *)key;
- (BOOL)doesiBSSExistsForKey:(NSString *)key;
- (void)iBSSCleanupForKey:(NSString *)key;

- (void)createCacheFolders;





@end

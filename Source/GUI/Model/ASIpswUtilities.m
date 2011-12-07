// -----------------------------------------------------------------------------
//  ASIpswUtilities.m
//  Ac1dSn0w
//
//  Created by Manuel Gebele (forensix) on 18.09.11.
//  Copyright (c) 2011-2012 Manuel Gebele (forensix).
//  All rights reserved.
// -----------------------------------------------------------------------------

#import "ASIpswUtilities.h"

#import <CommonCrypto/CommonDigest.h>

@implementation ASIpswUtilities

+ (NSString *)sha1HashForIpswAtPath:(NSString *)ipswPath
{
    unsigned char outputData[CC_SHA1_DIGEST_LENGTH];
    
    NSData *ipswData
    = [[[NSData alloc] initWithContentsOfFile:ipswPath] autorelease];
    
    CC_SHA1([ipswData bytes], [ipswData length], outputData);
    
    NSMutableString *sha1Hash
    = [[[NSMutableString alloc] init] autorelease];
    
    for (NSUInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [sha1Hash appendFormat:@"%02x", outputData[i]];
    }
    
    return sha1Hash;
}


+ (BOOL)untetheredJailbreakPossibleForFirmware:(NSString *)firmware
{
    return NO;
}


@end

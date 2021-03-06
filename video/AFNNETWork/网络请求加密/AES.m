//
//  AES.m
//  jiajiemiTest
//
//  Created by 10.12 on 2020/7/29.
//  Copyright © 2020 10.12. All rights reserved.
//

#import "AES.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

@implementation AES

#pragma mark - AES加密
+ (NSData *)AES128_Encrypt:(NSString *)key encryptData:(NSData *)data giv:(NSString *)gIv{

    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
+(NSString *)AES128_Encrypt:(NSString *)key encryptString:(NSString *)encryptText giv:(NSString *)gIv{
    
    NSData *data = [encryptText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData * encryData = [self AES128_Encrypt:key encryptData:data giv:gIv];
    NSString *output = [encryData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return output;
}

//AES128解密data(带自定义向量)
+ (NSData *)AES128_Decrypt:(NSString *)key encryptData:(NSData *)data giv:(NSString *)gIv{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}
+ (NSString *)AES128_Decrypt:(NSString *)key encryptString:(NSString *)encryptText giv:(NSString *)gIv{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData * encryptData =  [self AES128_Decrypt:key encryptData:data giv:gIv];
    NSString *output = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    return output;
}


//////////////


+ (NSData *)AES256_Encrypt:(NSString *)key encryptData:(NSData *)data giv:(NSString *)gIv{

    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
+(NSString *)AES256_Encrypt:(NSString *)key encryptString:(NSString *)encryptText giv:(NSString *)gIv{
    
    NSData *data = [encryptText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData * encryData = [self AES256_Encrypt:key encryptData:data giv:gIv];
    NSString *output = [encryData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return output;
}

//AES256解密data(带自定义向量)
+ (NSData *)AES256_Decrypt:(NSString *)key encryptData:(NSData *)data giv:(NSString *)gIv{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
//    kCCOptionECBMode
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}
+ (NSString *)AES256_Decrypt:(NSString *)key encryptString:(NSString *)encryptText giv:(NSString *)gIv{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData * encryptData =  [self AES256_Decrypt:key encryptData:data giv:gIv];
//    NSLog(@"encryptData == %@",encryptData);
//    NSError * error;
//    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:encryptData options:NSJSONReadingMutableContainers error:&error];
//
//    NSLog(@"responseObject == %@",responseObject);
//    NSLog(@"error == %@",error);
    NSString *output = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    return output;
}

/*
 *生成32为无序标示

 *

 *@return  32位无序标示

 */

+(NSString*)createUuid

{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];

}

@end

//
//  jiemishujuClass.m
//  video
//
//  Created by macbook on 2021/6/9.
//

#import "jiemishujuClass.h"

@implementation jiemishujuClass

+(instancetype)shareManager
{
    static jiemishujuClass * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[jiemishujuClass alloc]init];
    });
    return manager;
}
-(NSString*)jiamiData:(NSData*)data
{
        NSString *certsPath2 = [[NSBundle mainBundle] pathForResource:@"server-public" ofType:@"pem"];
        NSError *error2;
        NSString *contentInUTF82 = [NSString stringWithContentsOfFile:certsPath2
                        encoding:NSUTF8StringEncoding
                         error:&error2];
        NSString * aeskey = [AES createUuid];
        NSLog(@"随机key aeskey = %@",aeskey);
        NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString * aesstring =  [AES AES256_Encrypt:aeskey encryptString:datastring giv:@"abcdefghijklmnop"];
        NSString *RSAjiami = [RSA encryptString:aeskey publicKey:contentInUTF82];
        NSLog(@"AES string = %@",aesstring);
        NSLog(@"RSAjiami = %@",RSAjiami);
        NSString * jiamiPinJie = [NSString stringWithFormat:@"%@.%@",aesstring,RSAjiami];
    return jiamiPinJie;
}

-(NSString*)jiemiData:(NSData*)data
{
    NSString *result =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data转换string  === %@",result);
    NSArray *array = [result componentsSeparatedByString:@"."]; //分割成数组，前面是 json数据  后面是 加密的 key
//    NSLog(@"分割 array === %@",array);
    NSString *certsPath = [[NSBundle mainBundle] pathForResource:@"client-private" ofType:@"pem"];
    NSError *error;
    NSString *contentInUTF8 = [NSString stringWithContentsOfFile:certsPath
                    encoding:NSUTF8StringEncoding
                     error:&error];
//            NSLog(@"contentInUTF8 === %@",contentInUTF8);
    NSString *AESKEY = [RSA decryptString:array[1] privateKey:contentInUTF8];
    NSLog(@"用RSA解密后的AESKEY %@",AESKEY);
    NSString * JSONdata =  [AES AES256_Decrypt:AESKEY encryptString:array[0] giv:@"abcdefghijklmnop"];
    NSLog(@"AES解密后的JSON 数据 %@",JSONdata);
    return JSONdata;
}
@end

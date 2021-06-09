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


-(NSString*)jiemiData:(NSData*)data
{
    NSString *result =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data转换str result === %@",result);
    NSArray *array = [result componentsSeparatedByString:@"."]; //分割成数组，前面是 json数据  后面是 加密的 key
    NSLog(@"分割 array === %@",array);
    NSString *certsPath = [[NSBundle mainBundle] pathForResource:@"client-private" ofType:@"pem"];
    NSError *error;
    NSString *contentInUTF8 = [NSString stringWithContentsOfFile:certsPath
                    encoding:NSUTF8StringEncoding
                     error:&error];
//            NSLog(@"contentInUTF8 === %@",contentInUTF8);
    NSString *AESKEY = [RSA decryptString:array[1] privateKey:contentInUTF8];
    NSLog(@"RSA解密后的AESKEY %@",AESKEY);
    NSString * JSONshuju =  [AES AES256_Decrypt:AESKEY encryptString:array[0] giv:@"abcdefghijklmnop"];
    NSLog(@"AES解密后的JSONshuju %@",JSONshuju);
    return JSONshuju;
}
@end

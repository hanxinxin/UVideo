//
//  HttpManagement.m
//  GeneROV
//
//  Created by Daqi on 2018/6/23.
//  Copyright © 2018年 Mileda. All rights reserved.
//

#import "HttpManagement.h"
#import "AFNetworking.h"
#import "LaunchModel.h"
@implementation HttpManagement

+(instancetype)shareManager
{
    static HttpManagement * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HttpManagement alloc]init];
    });
    return manager;
}

//-(void)getStartScreenRequest:(nullable void (^)(LaunchModel *model,NSError *error))block
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //注意：responseObject:请求成功返回的响应结果（AFN内部已经把响应体转换为OC对象，通常是字典或数组）
//    LaunchModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:klaunch_path];
//    NSString *url = nil;
//    NSString *app_build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//
//
//    NSLog(@"url -- >%@",url);
//    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject)
//    {
//       LaunchModel *model = [LaunchModel JsonToDeviceModel:responseObject];
//        if (block)
//        {
//            [NSKeyedArchiver archiveRootObject:model toFile:klaunch_path];
//            block(model,nil);
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"失败---%@",error);
//        if (block) {
//            block(nil,error);
//        }
//    }];
//}



//    /// 加密流程
//    NSString *certsPath2 = [[NSBundle mainBundle] pathForResource:@"server-public" ofType:@"pem"];
//    NSError *error2;
//    NSString *contentInUTF82 = [NSString stringWithContentsOfFile:certsPath2
//                    encoding:NSUTF8StringEncoding
//                     error:&error2];
//    NSString * aeskey = [AES createUuid];
//    NSLog(@"随机key aeskey = %@",aeskey);
//    NSString * string =  [AES AES256_Encrypt:aeskey encryptString:@"AESKEY" giv:@"abcdefghijklmnop"];
//    NSString *RSAjiami = [RSA encryptString:aeskey publicKey:contentInUTF82];
//    NSLog(@"AES string = %@",string);
//    NSLog(@"RSAjiami = %@",RSAjiami);
    
    
////    解密流程
//    NSString *certsPath = [[NSBundle mainBundle] pathForResource:@"client-private" ofType:@"pem"];
//    NSError *error;
//    NSString *contentInUTF8 = [NSString stringWithContentsOfFile:certsPath
//                    encoding:NSUTF8StringEncoding
//                     error:&error];
//    NSLog(@"contentInUTF8 === %@",contentInUTF8);
//
//    NSString *RSAjiemi = [RSA decryptString:RSAjiami privateKey:contentInUTF8];
//    NSLog(@"RSA 加密后的数据 %@ 解密后的数据 %@",RSAjiami,RSAjiemi);
//
////
//    NSString * string1 =  [AES AES256_Decrypt:aeskey encryptString:string giv:@"abcdefghijklmnop"];
//    NSLog(@"AES jiemi string = %@",string1);
    


///// Get 请求
-(void)GetNetWork:(NSString * _Nullable )url success:(void (^_Nullable)(id _Nullable responseObject))success failure:(failureBlock _Nullable )failureBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        NSString*application= @"application/json";
//                [manager.requestSerializer setValue:application forHTTPHeaderField:@"content-type"];
    NSLog(@"get URL == %@",url);
            [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Get responseObject   = %@",responseObject);
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock(error);
                [UHud showHudWithStatus:@"网络异常"];

            }];
    
}

/// Post 请求
-(void)PostNewWork:(NSString * _Nullable )url Dictionary:(NSDictionary *_Nullable)params success:(SuccessBlock _Nullable )successBlock failure:(failureBlock _Nullable )failureBlock;
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString*application= @"application/json";
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    [manager.requestSerializer setValue:application forHTTPHeaderField:@"content-type"];
    NSString* timeStr=[self getCurrentTimestamp];
    [manager.requestSerializer setValue:usertoken forHTTPHeaderField:@"X-TOKEN"];
    [manager.requestSerializer setValue:timeStr forHTTPHeaderField:@"X-TIMESTAMP"];
    [manager.requestSerializer setValue:[self signaturemd5:params timestamp:timeStr] forHTTPHeaderField:@"X-SIGNATURE"];
    
//    加密要传输的数据
    NSString * jiamiData=nil;
    if(params!=nil)
    {
//        NSDictionary * dictZ = [[NSDictionary alloc] init];
//        NSArray * array = params.allKeys;
//        for (int i=0; i<array.count; i++) {
//            NSString*key=array[i];
//            NSString*Value=[params objectForKey:key];
//            NSString*ValueDecode=[Value stringByURLEncode];
////            [dictZ setValue:ValueDecode forKey:key];
//
//        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];

        jiamiData=[[jiemishujuClass shareManager] jiamiData:data];
    }else{
        NSData *data =[@"" dataUsingEncoding:NSUTF8StringEncoding];
        jiamiData=[[jiemishujuClass shareManager] jiamiData:data];
    }
    [manager POST:url parameters:jiamiData progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSData * data = (NSData*)responseObject;
                NSString * str = [[jiemishujuClass shareManager] jiemiData:data];
                NSDictionary *dict =[self dictionaryWithJsonString:str];
                NSLog(@"POST dict   = %@",dict);
                successBlock(dict);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock(error);
                [UHud showHudWithStatus:@"网络异常"];

            }];
   
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {

    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 获取当前时间戳
- (NSString *)getCurrentTimestamp {
NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
NSTimeInterval time = [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
return timeString;
}

-(NSString*)signaturemd5:(NSDictionary*)dict timestamp:(NSString*)timestamp
{
    NSString * dictStr=@"";
    NSArray * paixu1 = dict.allKeys;
    NSArray * paixu2 = [self paixuWith:paixu1];
    for (int i=0; i<paixu2.count; i++) {
        NSString*key=paixu2[i];
        NSString*Value=[dict objectForKey:key];
        NSString*ValueDecode=[Value stringByURLEncode];
        if(i==0)
        {
            dictStr=[NSString stringWithFormat:@"%@=%@",key,ValueDecode];
        }else{
            dictStr=[NSString stringWithFormat:@"%@&%@=%@",dictStr,key,ValueDecode];
        }
        NSLog(@"key = %@ , value = %@   ValueDecode=  %@",key,Value,ValueDecode);
    }
    
    NSString* pinjieStr=[NSString stringWithFormat:@"%@-%@-%@",usertoken,dictStr,timestamp];
    NSLog(@"签名 拼接后字符串  = %@",pinjieStr);
//    NSString * md5Str1=[NSString md5To32bit:pinjieStr];
    NSString * md5Str=[pinjieStr md5String];
    NSLog(@"md5Str = %@",md5Str);
    return md5Str;
}


//获取其拼音
- (NSString *)huoqushouzimuWithString:(NSString *)string{
    NSMutableString *ms = [[NSMutableString alloc]initWithString:string];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO);
    NSString *bigStr = [ms uppercaseString];
    NSString *cha = [bigStr substringToIndex:1];
    return cha;
}
//根据拼音的字母排序  ps：排序适用于所有类型
- (NSArray *)paixuWith:(NSArray *)array{
//    [array sortUsingComparator:^NSComparisonResult(Node *node1, Node *node2) {
//        NSString *string1 = [self huoqushouzimuWithString:node1.itemName];
//        NSString *string2 = [self huoqushouzimuWithString:node2.itemName];;
//        return [string1 compare:string2];
//    }];
//    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                NSString *string1 = [self huoqushouzimuWithString:obj1];
//                NSString *string2 = [self huoqushouzimuWithString:obj2];;
//                return [string1 compare:string2];
//    }];
    
    NSArray *sortedArray=[array sortedArrayUsingComparator:^(id a, id b) {
        NSString *string1 = [self huoqushouzimuWithString:a];
        NSString *string2 = [self huoqushouzimuWithString:b];;

        return [string1 compare:string2];

    }];
    return sortedArray;
}


@end

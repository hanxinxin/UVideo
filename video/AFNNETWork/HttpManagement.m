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


#define ACCEPTTYPEIMAGE @[@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json"]

@interface HttpManagement ()
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@end

@implementation HttpManagement
//@synthesize self.manager;
+(instancetype)shareManager
{
    static HttpManagement * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HttpManagement alloc]init];
    });
    return manager;
}

-(AFHTTPSessionManager *)manager
{
   if(!_manager)
   {
       _manager = [AFHTTPSessionManager manager];
   }
    return _manager;
}

-(void)StartcancelAllOperations
{
    [self.manager.operationQueue cancelAllOperations];
}

/// Post 请求
/**
 *  图片上传
 *
 *  @param imgArr 图片数组
 *  @param block  返回图片地址数组
 */
- (void)uploadImagesWihtImgArr:(NSArray *)imgArr
                           url:(NSString *)url
                     Tokenbool:(BOOL)Tokenbool
                    parameters:(id)parameters
                         block:(void (^)(id objc,BOOL success))block
                 blockprogress:(void(^)(id progress))progress{
    
    
//    AFHTTPSessionself.manager *self.manager = [AFHTTPSessionself.manager self.manager];
    self.manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString*application= @"application/json";
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPEIMAGE];
    NSString* timeStr=[self getCurrentTimestamp];
    [self.manager.requestSerializer setValue:usertoken forHTTPHeaderField:@"X-TOKEN"];
    [self.manager.requestSerializer setValue:timeStr forHTTPHeaderField:@"X-TIMESTAMP"];
    [self.manager.requestSerializer setValue:[self signaturemd5:parameters timestamp:timeStr] forHTTPHeaderField:@"X-SIGNATURE"];
    
    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imgArr.count; i++) {
            UIImage *image = imgArr[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
//            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/png"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress.fractionCompleted  == %f",uploadProgress.fractionCompleted);
        
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData * data = (NSData*)responseObject;
        NSString * str = [[jiemishujuClass shareManager] jiemiData:data];
        NSDictionary *dict =[self dictionaryWithJsonString:str];
        block(dict,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(error,NO);
    }];
   
}



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
    
//    AFHTTPSessionManager *self.manager = [AFHTTPSessionManager self.manager];
    self.manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        NSString*application= @"application/json";
//                [self.manager.requestSerializer setValue:application forHTTPHeaderField:@"content-type"];
    NSLog(@"get URL == %@",url);
            [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Get responseObject   = %@",responseObject);
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock(error);
                [UHud showHudWithStatus:@"网络异常"];

            }];
    
}

/// Post 请求
-(void)PostNewWork:(NSString * _Nullable )url Dictionary:(NSDictionary *_Nullable)params success:(SuccessBlock _Nullable )successBlock failure:(failureBlock _Nullable )failureBlock
{
    
//    AFHTTPSessionManager *self.manager = [AFHTTPSessionManager self.manager];
    self.manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString*application= @"application/json";
    self.manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    [self.manager.requestSerializer setValue:application forHTTPHeaderField:@"content-type"];
    NSString* timeStr=[self getCurrentTimestamp];
    [self.manager.requestSerializer setValue:usertoken forHTTPHeaderField:@"X-TOKEN"];
    [self.manager.requestSerializer setValue:timeStr forHTTPHeaderField:@"X-TIMESTAMP"];
    [self.manager.requestSerializer setValue:[self signaturemd5:params timestamp:timeStr] forHTTPHeaderField:@"X-SIGNATURE"];
    
//    加密要传输的数据
    NSString * jiamiData=nil;
    if(params!=nil)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];

        jiamiData=[[jiemishujuClass shareManager] jiamiData:data];
    }else{
        NSData *data =[@"" dataUsingEncoding:NSUTF8StringEncoding];
        jiamiData=[[jiemishujuClass shareManager] jiamiData:data];
    }
    [self.manager POST:url parameters:jiamiData progress:^(NSProgress * _Nonnull uploadProgress) {

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
    NSString * md5Str=[[pinjieStr lowercaseString] md5String];  ////转为 小写后再 md5加密
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
//        NSString *string1 = [self huoqushouzimuWithString:a];
//        NSString *string2 = [self huoqushouzimuWithString:b];;

        return [a compare:b];

    }];
    return sortedArray;
}


@end

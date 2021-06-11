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
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-TOKEN"];
//    [manager.requestSerializer setValue:shijianchuo forHTTPHeaderField:@"X-TIMESTAMP"];
//    [manager.requestSerializer setValue:jianming forHTTPHeaderField:@"X-SIGNATURE"];
    
//    加密要传输的数据
//    NSString * jiamiData=nil;
//    if(params!=nil)
//    {
//        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//
//        jiamiData=[[jiemishujuClass shareManager] jiamiData:data];
//    }
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"POST responseObject   = %@",responseObject);
                successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock(error);
                [UHud showHudWithStatus:@"网络异常"];

            }];
   
}




@end

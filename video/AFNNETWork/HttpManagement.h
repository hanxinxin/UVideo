//
//  HttpManagement.h
//  GeneROV
//
//  Created by Daqi on 2018/6/23.
//  Copyright © 2018年 Mileda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchModel.h"
//typedef void(^successBlock)(NSString * _Nullable resultStatus,NSString * _Nullable resultMsg,NSMutableArray * _Nullable dataArray);
typedef void(^failureBlock)(NSError * _Nullable error);
/**
 http通讯成功的block

 @param responseObject 返回的数据
 */
typedef void (^SuccessBlock)(id _Nullable responseObject);
@interface HttpManagement : NSObject
+(instancetype _Nullable )shareManager;

/// 取消网络请求
-(void)StartcancelAllOperations;

-(void)getStartScreenRequest:(nullable void (^)(LaunchModel * _Nullable model,NSError * _Nullable error))block;

/// Get 请求
-(void)GetNetWork:(NSString * _Nullable )url success:(void (^_Nullable)(id _Nullable responseObject))success failure:(failureBlock _Nullable )failureBlock;

/// Post 请求
-(void)PostNewWork:(NSString * _Nullable )url Dictionary:(NSDictionary *_Nullable)params success:(SuccessBlock _Nullable )successBlock failure:(failureBlock _Nullable )failureBlock;


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
                 blockprogress:(void(^)(id progress))progress;


@end

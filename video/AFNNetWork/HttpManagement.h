//
//  HttpManagement.h
//  GeneROV
//
//  Created by Daqi on 2018/6/23.
//  Copyright © 2018年 Mileda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchModel.h"
typedef void(^successBlock)(NSString * _Nullable resultStatus,NSString * _Nullable resultMsg,NSMutableArray * _Nullable dataArray);
typedef void(^failureBlock)(NSError * _Nullable error);
@interface HttpManagement : NSObject
+(instancetype _Nullable )shareManager;

-(void)getStartScreenRequest:(nullable void (^)(LaunchModel * _Nullable model,NSError * _Nullable error))block;

/// Get 请求
-(void)GetNetWork:(NSString * _Nullable )url success:(void (^_Nullable)(id _Nullable))success failure:(failureBlock _Nullable )failureBlock;

/// Post 请求
-(void)PostNewWork:(NSString * _Nullable )url Dictionary:(NSDictionary *_Nullable)params success:(successBlock _Nullable )successBlock failure:(failureBlock _Nullable )failureBlock;

@end

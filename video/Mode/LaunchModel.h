//
//  LaunchModel.h
//  GeneROV
//
//  Created by Daqi on 2018/5/17.
//  Copyright © 2018年 Mileda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchModel : NSObject<NSCopying>
@property(nonatomic,assign)int uCode;
@property(nonatomic,assign)int uVerName;
@property(nonatomic,copy)NSString *uFileName;
@property(nonatomic,copy)NSString *uDownLoadUrl;
+(LaunchModel *)JsonToDeviceModel:(NSDictionary *)dict;
@end

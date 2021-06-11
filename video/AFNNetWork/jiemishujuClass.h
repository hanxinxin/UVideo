//
//  jiemishujuClass.h
//  video
//
//  Created by macbook on 2021/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface jiemishujuClass : NSObject
+(instancetype)shareManager;

/// 加密
/// @param data 要加密的数据
-(NSString*)jiamiData:(NSData*)data;

/// 解密
/// @param data 要解密的数据
-(NSString*)jiemiData:(NSData*)data;
@end

NS_ASSUME_NONNULL_END

//
//  videoFenleiMode.h
//  video
//
//  Created by macbook on 2021/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class videoFenleiMode;
@interface videoFenleiMode : NSObject
@property(nonatomic,assign) double id;//分类id
@property(nonatomic,assign) double pid;// 上级id
@property(nonatomic,assign) NSString* name;// 分类名称
@property(nonatomic,assign) NSString* icon;// 图标地址


- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

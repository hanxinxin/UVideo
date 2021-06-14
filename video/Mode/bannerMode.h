//
//  bannerMode.h
//  video
//
//  Created by macbook on 2021/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface bannerMode : NSObject
@property(nonatomic,assign) NSNumber* blank;//是否新打开页面[1=是 0=否]
@property(nonatomic,assign) NSString* source;// 图片地址
@property(nonatomic,assign) NSString* subtitle;// 副标题
@property(nonatomic,assign) NSString* title;// 主标题
@property(nonatomic,assign) NSString* url ;// 跳转地址


- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

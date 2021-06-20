//
//  VideoRankMode.m
//  video
//
//  Created by macbook on 2021/6/14.
//

#import "VideoRankMode.h"

@implementation VideoRankMode
@synthesize description = _description;//适用于所有特性的数据类型
+(NSDictionary *)mj_replacedKeyFromPropertyName {
  return @{@"Id" : @"id"};
}
- (instancetype)initWithDictionary:(NSDictionary *)dict

{

if (self = [super init]) {

[self setValuesForKeysWithDictionary:dict];

}

return self;

}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict

{

return [[self alloc] initWithDictionary:dict];

}
@end

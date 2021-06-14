//
//  VideoRankMode.m
//  video
//
//  Created by macbook on 2021/6/14.
//

#import "VideoRankMode.h"

@implementation VideoRankMode
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

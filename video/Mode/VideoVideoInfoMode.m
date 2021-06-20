//
//  VideoVideoInfoMode.m
//  video
//
//  Created by macbook on 2021/6/15.
//

#import "VideoVideoInfoMode.h"

@implementation VideoVideoInfoMode
@synthesize description = _description;//适用于所有特性的数据类型
+(NSDictionary *)mj_replacedKeyFromPropertyName {
  return @{@"Id" : @"id"};
}
@end

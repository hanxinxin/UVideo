//
//  LaunchModel.m
//  GeneROV
//
//  Created by Daqi on 2018/5/17.
//  Copyright © 2018年 Mileda. All rights reserved.
//

#import "LaunchModel.h"
#import "MJExtension.h"

@implementation LaunchModel

+(LaunchModel *)JsonToDeviceModel:(NSDictionary *)dict
{
    LaunchModel *shareModel = [LaunchModel mj_objectWithKeyValues:dict];
    NSLog(@"url = %@",shareModel.uDownLoadUrl);
    return shareModel;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.uCode = [aDecoder decodeIntForKey:@"uCode"];
        self.uVerName = [aDecoder decodeIntForKey:@"uVerName"];
        self.uFileName = [aDecoder decodeObjectForKey:@"uFileName"];
        self.uDownLoadUrl = [aDecoder decodeObjectForKey:@"uDownLoadUrl"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //    @property(nonatomic,assign)int uCode;
    //    @property(nonatomic,assign)int uVerNum;
    //    @property(nonatomic,copy)NSString *uFileName;
    //    @property(nonatomic,copy)NSString *uDownLoadUrl;
    [aCoder encodeInteger:self.uCode forKey:@"uCode"];
    [aCoder encodeInteger:self.uVerName forKey:@"uVerName"];
    [aCoder encodeObject:self.uFileName forKey:@"uFileName"];
    [aCoder encodeObject:self.uDownLoadUrl forKey:@"uDownLoadUrl"];
}
@end

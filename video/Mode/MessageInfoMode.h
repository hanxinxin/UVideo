//
//  MessageInfoMode.h
//  video
//
//  Created by macbook on 2021/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MessageInfoMode;


@interface MessageInfoMode : NSObject
@property (nonatomic, assign) double read_time;
@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double create_time;
@end
NS_ASSUME_NONNULL_END

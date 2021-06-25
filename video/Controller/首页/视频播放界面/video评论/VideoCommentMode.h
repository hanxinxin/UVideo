//
//  VideoCommentMode.h
//  video
//
//  Created by nian on 2021/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoCommentMode;


@interface VideoCommentMode : NSObject
@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) double uid;
@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, assign) double create_time;
@end
NS_ASSUME_NONNULL_END

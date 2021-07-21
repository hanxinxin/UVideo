//
//  VideoVideosource.h
//  video
//
//  Created by nian on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoVideosource;


@interface VideoVideosource : NSObject
@property (nonatomic, assign) double quality;
@property (nonatomic, assign) double front_start_duration;
@property (nonatomic, assign) double tail_duration;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) double front_duration;
@property (nonatomic, assign) double tail_end_duration;
@end

NS_ASSUME_NONNULL_END

//
//  VideoFavoriteMode.h
//  video
//
//  Created by nian on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class VideoFavoriteMode;


@interface VideoFavoriteMode : NSObject
@property (nonatomic, assign) double video_comment;
@property (nonatomic, assign) double video_duration;
@property (nonatomic, assign) double video_appreciate;
@property (nonatomic, copy) NSString *video_state;
@property (nonatomic, assign) double create_time;
@property (nonatomic, assign) double video_favorite;
@property (nonatomic, copy) NSString *video_title;
@property (nonatomic, assign) double video_id;
@property (nonatomic, copy) NSString *video_description;
@property (nonatomic, assign) double video_score;
@property (nonatomic, copy) NSString *video_language;
@property (nonatomic, assign) double multiple_fragment;
@property (nonatomic, assign) double video_category_id;
@property (nonatomic, assign) double video_depreciate;
@property (nonatomic, copy) NSString *video_region;
@property (nonatomic, copy) NSString *video_starring;
@property (nonatomic, assign) double id;
@property (nonatomic, assign) double video_hits;
@property (nonatomic, copy) NSString *video_year;
@property (nonatomic, copy) NSString *video_director;
@property (nonatomic, assign) double video_paid;
@property (nonatomic, copy) NSString *video_pic;
@property (nonatomic, assign) double video_kind;
@property (nonatomic, copy) NSString *video_remark;
@property (nonatomic, copy) NSString *last_fragment_symbol;
@property (nonatomic, assign) double video_parent_category_id;
@end

NS_ASSUME_NONNULL_END

//
//  VideoVideoInfoMode.h
//  video
//
//  Created by macbook on 2021/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoVideoInfoMode;


@interface VideoVideoInfoMode : NSObject
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double duration;
@property (nonatomic, assign) double create_time;
@property (nonatomic, assign) double favorite;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, assign) double hits;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double appreciate;
@property (nonatomic, copy) NSString *starring;
@property (nonatomic, assign) double kind;
@property (nonatomic, assign) double parent_category_id;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) double paid;
@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *title_alias;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) double depreciate;
@property (nonatomic, copy) NSString *director;
@property (nonatomic, assign) double category_id;
@property (nonatomic, assign) double comment;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *description;
@end

NS_ASSUME_NONNULL_END

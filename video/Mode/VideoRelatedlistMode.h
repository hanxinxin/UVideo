//
//  VideoRelatedlistMode.h
//  video
//
//  Created by macbook on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoRelatedlistMode;


@interface VideoRelatedlistMode : NSObject
@property (nonatomic, assign) double id;
@property (nonatomic, assign) double paid;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) double category_id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, assign) double kind;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double create_time;
@property (nonatomic, assign) double parent_category_id;
@end

NS_ASSUME_NONNULL_END

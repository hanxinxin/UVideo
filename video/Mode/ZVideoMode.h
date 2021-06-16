//
//  ZVideoMode.h
//  video
//
//  Created by macbook on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import "VideoVideoInfoMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZVideoMode : NSObject
//@property (nonatomic, strong) VideoVideoInfoMode*model;
@property (nonatomic, strong) NSDictionary*video;
@property (nonatomic, assign) double in_favorite;                     // 是否已收藏[0=否 1=是]
@property (nonatomic, assign) double in_evaluate;                     // 是否已评价(赞或踩)[0=否 1=是]
@property (nonatomic, assign) double evaluate_type;                   // 评价类型[0=未评价 大于0=赞 小于0=踩]
@property (nonatomic, copy) NSArray * video_fragment_list;           // 分集列表
@property (nonatomic, copy) NSArray*related_list;                  // 相关剧集列表
@end

NS_ASSUME_NONNULL_END

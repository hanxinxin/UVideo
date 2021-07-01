//
//  GuanggaoMode.h
//  video
//
//  Created by nian on 2021/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GuanggaoMode;


@interface GuanggaoMode : NSObject
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double duration;
@property (nonatomic, copy) NSString *category_symbol;
@property (nonatomic, assign) double category_type;
@property (nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END

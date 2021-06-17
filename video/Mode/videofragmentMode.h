//
//  videofragmentMode.h
//  video
//
//  Created by macbook on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class videofragmentMode;
@interface videofragmentMode : NSObject
@property (nonatomic, assign) double id;
@property (nonatomic, assign) double symbol;
@property (nonatomic, strong) NSArray *qualities;
@end

NS_ASSUME_NONNULL_END

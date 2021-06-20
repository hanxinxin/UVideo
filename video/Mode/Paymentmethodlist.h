//
//  Paymentmethodlist.h
//  video
//
//  Created by macbook on 2021/6/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Paymentmethodlist;
@interface Paymentmethodlist : NSObject

@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END

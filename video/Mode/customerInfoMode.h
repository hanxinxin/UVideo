//
//  customerInfoMode.h
//  video
//
//  Created by macbook on 2021/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class customerInfoMode;


@interface customerInfoMode : NSObject
@property (nonatomic, assign) double id;
@property (nonatomic, assign) double wechat_state;
@property (nonatomic, assign) double qq_state;
@property (nonatomic, assign) double mobile_state;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) double email_state;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *wechat_qrcode;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END

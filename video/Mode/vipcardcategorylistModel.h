//
//  vipcardcategorylistModel.h
//  video
//
//  Created by macbook on 2021/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class vipcardcategorylistModel;


@interface vipcardcategorylistModel : NSObject
@property (nonatomic, assign) double integral;
@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double period;
@property (nonatomic, copy) NSString *price;
@end

NS_ASSUME_NONNULL_END

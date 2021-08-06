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
@property (nonatomic, assign) double id;
@property (nonatomic, assign) double promotion_id;
@property (nonatomic, assign) double firstc_add_days;
@property (nonatomic, assign) double period;
@property (nonatomic, assign) double add_days;
@property (nonatomic, copy) NSString *discounted_price;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) double level;
@property (nonatomic, copy) NSString *firstc_discounted_price;
@property (nonatomic, assign) double integral;
@property (nonatomic, assign) double first_charge;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END

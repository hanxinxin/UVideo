//
//  NewFAQViewController.h
//  video
//
//  Created by macbook on 2021/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface faqcategorymodel : NSObject
@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *name;
@end

@interface faqListInfomodel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) double id;
@property (nonatomic, copy) NSString *title;
@end

@interface NewFAQViewController : HXBaseViewController

@end

NS_ASSUME_NONNULL_END

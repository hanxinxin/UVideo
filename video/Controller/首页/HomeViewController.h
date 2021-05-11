//
//  HomeViewController.h
//  video
//
//  Created by nian on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "ScrollPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : ScrollPageViewController
@property (nonatomic, copy) NSString *searchStr;
@end

NS_ASSUME_NONNULL_END

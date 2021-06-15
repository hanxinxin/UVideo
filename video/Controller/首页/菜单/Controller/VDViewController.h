//
//  VDViewController.h
//  video
//
//  Created by nian on 2021/3/11.
//

#import <UIKit/UIKit.h>
#import "videoFenleiMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface VDViewController : hxViewController
/** shopsDS */
@property (nonatomic, strong) NSMutableArray *shopsDS;
/** shopsDY */
@property (nonatomic, strong) NSMutableArray *shopsDY;
@property (nonatomic, strong) videoFenleiMode * FenleiMode;
@property (nonatomic, assign) NSInteger SelectIndex;
@end

NS_ASSUME_NONNULL_END

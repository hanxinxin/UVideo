//
//  VDHomeOneViewController.h
//  video
//
//  Created by macbook on 2021/7/22.
//

#import <UIKit/UIKit.h>
#import "videoFenleiMode.h"
#import "homeOneTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface VDHomeOneViewController : hxViewController
/** shopsDS */
@property (nonatomic, strong) NSMutableArray *shopsDS;
/** shopsDY */
@property (nonatomic, strong) NSMutableArray *shopsDY;
@property (nonatomic, strong) videoFenleiMode * FenleiMode;
@property (nonatomic, assign) NSInteger SelectIndex;
@end

NS_ASSUME_NONNULL_END

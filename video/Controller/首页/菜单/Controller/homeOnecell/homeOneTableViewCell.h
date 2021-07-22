//
//  homeOneTableViewCell.h
//  video
//
//  Created by macbook on 2021/7/22.
//

#import <UIKit/UIKit.h>
#import "videoFenleiMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface homeOneTableViewCell : UITableViewCell
/** shopsDS */
@property (nonatomic, strong) NSMutableArray *shopsDS;

/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView1;
@property (nonatomic, assign) NSInteger parent_category_id;
@property (nonatomic, strong) videoFenleiMode * model;
@end

NS_ASSUME_NONNULL_END

//
//  homeOneTableViewCell.h
//  video
//
//  Created by macbook on 2021/7/22.
//

#import <UIKit/UIKit.h>
#import "videoFenleiMode.h"
#import "ZVideoMode.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^homeOneTableViewCellBlock)(NSInteger item,VideoRankMode *Cellmodel); //0为取消  1为确定



@interface homeOneTableViewCell : UITableViewCell
/** shopsDS */
@property (nonatomic, strong) NSMutableArray *shopsDS;

/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView1;
@property (nonatomic, assign) NSInteger parent_category_id;
@property (nonatomic, strong) videoFenleiMode * model;
@property (nonatomic,copy) homeOneTableViewCellBlock touchIndex;
@end

NS_ASSUME_NONNULL_END

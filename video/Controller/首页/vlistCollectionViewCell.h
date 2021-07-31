//
//  vlistCollectionViewCell.h
//  video
//
//  Created by macbook on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "TopLeftLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface vlistCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet TopLeftLabel *downTitle;
@property (strong, nonatomic) VideoRankMode * model;
@end

NS_ASSUME_NONNULL_END

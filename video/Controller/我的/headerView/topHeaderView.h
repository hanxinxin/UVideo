//
//  topHeaderView.h
//  video
//
//  Created by macbook on 2021/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface topHeaderView : UIView
@property (strong, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *txImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *vipImage;
@property (weak, nonatomic) IBOutlet UILabel *vipTime;
@property (weak, nonatomic) IBOutlet UILabel *jinbiLabel;


@end

NS_ASSUME_NONNULL_END

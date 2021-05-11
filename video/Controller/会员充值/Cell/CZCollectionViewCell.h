//
//  CZCollectionViewCell.h
//  video
//
//  Created by macbook on 2021/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipbg;

@end

NS_ASSUME_NONNULL_END

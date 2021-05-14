//
//  topHeaderView.h
//  video
//
//  Created by macbook on 2021/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^topHeaderBlock)(NSInteger touchIndex); //1001 点击头像 1002点击积分  1003 点击VIP按钮
typedef void(^cellindexBlock)(NSInteger CellIndex);

@interface topHeaderView : UIView
@property (strong, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *txImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *vipImage;
@property (weak, nonatomic) IBOutlet UILabel *vipTime;
@property (weak, nonatomic) IBOutlet UILabel *jinbiLabel;
@property (weak, nonatomic) IBOutlet UIButton *jifenBtn;

@property (nonatomic,copy) topHeaderBlock topHeaderBlock;
@property (nonatomic,copy) cellindexBlock cellindexBlock;
@end

NS_ASSUME_NONNULL_END

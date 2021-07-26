//
//  ClarityView.h
//  video
//
//  Created by macbook on 2021/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClarityView : UIView
/** 详情按钮回调 **/
@property (nonatomic,copy) void(^ClarityCallBack)(NSIndexPath * indexPath);


@property (nonatomic, weak) UICollectionView *collectionView1;
@property (nonatomic, strong)NSArray * titleNumberarray;
@property (nonatomic, assign)NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END

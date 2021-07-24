//
//  SliderTableViewCell.h
//  video
//
//  Created by nian on 2021/5/10.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SliderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *bfbLabel;
@property (weak, nonatomic) IBOutlet UIView *left_downView;
@property(nonatomic,strong)YTSliderView* Slider;
@end

NS_ASSUME_NONNULL_END

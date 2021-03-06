//
//  VideoTableViewCell.h
//  video
//
//  Created by nian on 2021/3/11.
//

#import <UIKit/UIKit.h>
#import "TopLeftLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet TopLeftLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

NS_ASSUME_NONNULL_END

//
//  LXTableViewCell.h
//  video
//
//  Created by nian on 2021/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *videoTime;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (weak, nonatomic) IBOutlet UILabel *VideoSize;
@property (weak, nonatomic) IBOutlet UILabel *VideoJindu;

@end

NS_ASSUME_NONNULL_END

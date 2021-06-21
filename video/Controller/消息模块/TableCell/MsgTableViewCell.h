//
//  MsgTableViewCell.h
//  video
//
//  Created by nian on 2021/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *miaoshuLabel;

@property (weak, nonatomic) IBOutlet UILabel *readRedLabel;

@end

NS_ASSUME_NONNULL_END

//
//  FAQTableViewCell.h
//  video
//
//  Created by nian on 2021/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FAQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftimage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

NS_ASSUME_NONNULL_END

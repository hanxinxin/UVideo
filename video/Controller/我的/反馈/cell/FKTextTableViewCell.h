//
//  FKTextTableViewCell.h
//  video
//
//  Created by macbook on 2021/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FKTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Toptitle;
@property (weak, nonatomic) IBOutlet UITextView *NeiRongTextView;

@end

NS_ASSUME_NONNULL_END

//
//  zdyTableViewCell.m
//  video
//
//  Created by nian on 2021/8/12.
//

#import "zdyTableViewCell.h"

static CGFloat kCell_margin = 15;
@implementation zdyTableViewCell
- (void)setFrame:(CGRect)frame {
    frame.origin.x += kCell_margin;

    frame.size.width -= 2 * kCell_margin;

    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

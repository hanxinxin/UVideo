//
//  FKnumberTableViewCell.m
//  video
//
//  Created by macbook on 2021/6/20.
//

#import "FKnumberTableViewCell.h"
static CGFloat kCell_margin = 15;
@implementation FKnumberTableViewCell
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

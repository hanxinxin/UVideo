//
//  MsgTableViewCell.m
//  video
//
//  Created by nian on 2021/5/11.
//

#import "MsgTableViewCell.h"

@implementation MsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.readRedLabel.clipsToBounds = YES;
    self.readRedLabel.layer.cornerRadius=4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

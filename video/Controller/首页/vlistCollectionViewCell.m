//
//  vlistCollectionViewCell.m
//  video
//
//  Created by macbook on 2021/6/7.
//

#import "vlistCollectionViewCell.h"

@implementation vlistCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(VideoRankMode *)model
{
    _model = model;
    
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"image"]];
    self.downTitle.text=model.title;
}


@end

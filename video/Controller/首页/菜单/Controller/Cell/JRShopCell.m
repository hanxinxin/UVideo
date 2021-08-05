//
//  XXShopCell.m
//  WaterFallLayout
//
//  Created by sky on 16/6/6.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JRShopCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+VerticalAlign.h"
#import "JRShop.h"
#import "TopLeftLabel.h"

@interface JRShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet TopLeftLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation JRShopCell

//- (void)setShop:(JRShop *)shop
//{
//    _shop = shop;
//
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"image"]];
//    self.priceLabel.layer.cornerRadius=4;
//    self.priceLabel.text = shop.price;
//    self.infoLabel.layer.cornerRadius=4;
//    self.infoLabel.text = shop.price;
//}
- (void)setShop:(VideoRankMode *)shop
{
    _shop = shop;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.pic] placeholderImage:[UIImage imageNamed:@"videoGBimage"]];
    
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius=4;
    self.priceLabel.layer.cornerRadius=4;
    self.priceLabel.text = shop.title;
    self.infoLabel.layer.cornerRadius=4;
    self.infoLabel.text = shop.title_alias;
//    [self.priceLabel alignTop];
}


@end

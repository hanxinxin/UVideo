//
//  SCJTableViewCell.h
//  video
//
//  Created by macbook on 2021/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCJTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTime;
@property (weak, nonatomic) IBOutlet UILabel *movietitle;
@property (weak, nonatomic) IBOutlet UIView *biaoqian;
@property (weak, nonatomic) IBOutlet UILabel *liulanTime;
//@property (weak, nonatomic) IBOutlet UIButton *shuomingBtn;
@property (weak, nonatomic) IBOutlet UILabel *shuomingMiaoshu;


-(void)addBiaoqianLabel:(NSArray*)textArr;

@end

NS_ASSUME_NONNULL_END

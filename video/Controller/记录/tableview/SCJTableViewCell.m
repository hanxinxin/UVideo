//
//  SCJTableViewCell.m
//  video
//
//  Created by macbook on 2021/5/9.
//

#import "SCJTableViewCell.h"

@implementation SCJTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftImage.layer.masksToBounds = YES;
    self.leftImage.layer.cornerRadius=4;
}

-(void)addBiaoqianLabel:(NSArray*)textArr
{
    [self.biaoqian removeAllSubviews];
    CGFloat y = 0;
    CGFloat letfWidth = 0;
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 30;
        if (letfWidth + width + 15 > self.biaoqian.width) {
            if (y >= 130 && [text isEqualToString:@"最近搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            letfWidth = 0;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ceil(letfWidth), ceil(y), ceil(width), 24)];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.text = text;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 4;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGB(111, 111, 111);
        label.layer.borderColor=[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
        label.backgroundColor=[UIColor whiteColor];
//        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [self.biaoqian addSubview:label];
        letfWidth += width + 10;
    }
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}
- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
}
//处理选中背景色问题
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!self.editing) {
        return;
    }
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
      
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    return;
}

@end

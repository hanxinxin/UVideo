//
//  PanTableViewCell.m
//  PanYuanFeng
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 lianzhonghulian. All rights reserved.
//

#import "PanTableViewCell.h"
#import "PanCollectionViewCell.h"
#define KWidth [UIScreen mainScreen].bounds.size.width

@interface PanTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UICollectionView *mainView;
@property(strong,nonatomic)NSIndexPath * indexPath;
@end

@implementation PanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
//初始化cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.mainView reloadData];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setUpViews{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 5);
    self.mainView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    [self.mainView registerNib:[UINib nibWithNibName:@"PanCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PanCollectionViewCell"];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    self.mainView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.mainView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [self calculateRowWidth:self.dataArr[indexPath.row]];
    return CGSizeMake(width+15, 30) ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PanCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PanCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.showLabel.text = self.dataArr[indexPath.row];
    if (self.indexPath == indexPath) {
        cell.showLabel.textColor = [UIColor redColor];
    }else{
        cell.showLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.indexPath  = indexPath;
    if (self.deleget && [self.deleget respondsToSelector:@selector(SelectWhichlabel:)]) {
        [self.deleget SelectWhichlabel:self.dataArr[indexPath.row]];
    }
    [self.mainView reloadData];
}
//计算文字宽度
-(CGFloat)calculateRowWidth:(NSString*)string {
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
@end

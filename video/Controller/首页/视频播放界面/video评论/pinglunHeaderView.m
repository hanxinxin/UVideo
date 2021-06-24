//
//  pinglunHeaderView.m
//  video
//
//  Created by macbook on 2021/6/24.
//

#import "pinglunHeaderView.h"

@interface pinglunHeaderView ()

/** commentView **/
@property (nonatomic , weak) UIView *commentView ;
/** titleView*/
@property (nonatomic , strong) UIView *titleView;

/** 评论 */
@property (nonatomic , strong) UILabel *commentLabel;
/** 评论按钮 */
@property (nonatomic , strong) UIButton *pinglunBtn;

@end
@implementation pinglunHeaderView

+ (instancetype)commentHeaderView
{
    return [[self alloc] init];
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"pinglunHeaderView";
    pinglunHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        // 创建自控制器
        [self _setupSubViews];;
    }
    return self;
}


-(void)_setupSubViews
{
    
    // 评论View
    UIView *commentView = [[UIView alloc] initWithFrame:self.bounds];
    commentView.backgroundColor = [UIColor redColor];
    self.commentView = commentView;
    [self.contentView addSubview:commentView];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    [self.titleView setBackgroundColor:[UIColor blueColor]];
    [self.commentView addSubview:self.titleView];
    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0 , self.titleView.width-60, 30)];
    self.commentLabel.text=@"评论";
    [self.commentLabel setTintColor:[UIColor blackColor]];
    [self.commentLabel setFont:[UIFont systemFontOfSize:18.f]];
    [self.titleView addSubview:self.commentLabel];
    
    self.pinglunBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.commentLabel.right, 0, self.titleView.width-self.commentLabel.width, 30)];
    [self.pinglunBtn setImage:[UIImage imageNamed:@"pinglun"] forState:(UIControlStateNormal)];
    [self.pinglunBtn setTitle:@"评论" forState:(UIControlStateNormal)];
    [self.pinglunBtn setTintColor:[UIColor blackColor]];
    [self.pinglunBtn addTarget:self action:@selector(pinglun_touch:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.titleView addSubview:self.pinglunBtn];
    
}

-(void)pinglun_touch:(id)sender
{
    
}

@end

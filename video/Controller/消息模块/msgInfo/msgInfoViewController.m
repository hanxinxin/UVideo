//
//  msgInfoViewController.m
//  video
//
//  Created by nian on 2021/5/11.
//

#import "msgInfoViewController.h"

@interface msgInfoViewController ()
@property(nonatomic,strong)UIView*InfoView;

@end

@implementation msgInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)addInfoViewA
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(16,16,SCREEN_WIDTH-32,SCREENH_HEIGHT-16);
    view.alpha = 1.0;
    view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    view.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,3);
    view.layer.shadowRadius = 6;
    view.layer.shadowOpacity = 1;
    self.InfoView=view;
    [self.view addSubview:self.InfoView];
}
@end

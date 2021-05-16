//
//  lxkfViewController.m
//  video
//
//  Created by macbook on 2021/5/16.
//

#import "lxkfViewController.h"

@interface lxkfViewController ()

@end

@implementation lxkfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"在线联系";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    
    
    [self initUI];
}
-(void)initUI
{
    self.erweimaView.layer.borderColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0].CGColor;
    self.erweimaView.layer.borderWidth = 1;
    self.erweimaView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.erweimaView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.erweimaView.layer.shadowOffset = CGSizeMake(0,3);
    self.erweimaView.layer.shadowRadius = 6;
    self.erweimaView.layer.shadowOpacity = 1;
    self.erweimaView.layer.cornerRadius = 14;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

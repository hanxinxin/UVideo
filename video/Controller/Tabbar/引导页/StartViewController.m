//
//  StartViewController.m
//  DaYingTech
//
//  Created by Daqi on 2018/6/7.
//  Copyright © 2018年 DaYing. All rights reserved.
//

#import "StartViewController.h"
#import "DHGuidePageHUD.h"
#import "AppDelegate.h"
#import "GlobalConfig.h"
@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStaticGuidePage];
    // Do any additional setup after loading the view.
}

- (void)setStaticGuidePage
{
    NSArray *imageNameArray = nil;
    imageNameArray = @[@"timg8",@"timg8",@"timg8"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    LRWeakSelf(self)
    [guidePage setClickActionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself startLogin];
        });
    }];
    [self.navigationController.view addSubview:guidePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLogin
{

//        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//        [delegate.window startLogin];

    
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

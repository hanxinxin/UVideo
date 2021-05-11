//
//  AppDelegate.h
//  video
//
//  Created by nian on 2021/3/9.
//

#import <UIKit/UIKit.h>
#import "MHAccount.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;


/**
 *  用户数据 只读
 */
@property (nonatomic, readonly , strong) MHAccount *account;

/**
 *  获取delegate
 *
 */
+ (AppDelegate *)sharedDelegate;

@end


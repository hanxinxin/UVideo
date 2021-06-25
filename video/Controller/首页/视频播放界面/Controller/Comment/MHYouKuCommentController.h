//
//  MHYouKuCommentController.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHViewController.h"
@protocol MHYouKuCommentControllerDelegate <NSObject>



- (void)editokController:(NSString*)text;

@end
@interface MHYouKuCommentController : MHViewController
/** 视频id */
@property (nonatomic , copy) NSString *mediabase_id;
@property (nonatomic, weak) id <MHYouKuCommentControllerDelegate> delegate;
@end

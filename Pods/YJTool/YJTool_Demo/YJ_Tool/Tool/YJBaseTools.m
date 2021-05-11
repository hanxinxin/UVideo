//
//  YJBaseTools.m
//  YJTool_Demo
//
//  Created by yangjian on 2019/7/16.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import "YJBaseTools.h"

@implementation YJBaseTools

+ (void)showAltMsg:(NSString *)msg{
    
    NSString *str = msg;
    if (!msg || ![msg isKindOfClass:[NSString class]]) {
        str = @"连接服务器失败";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:str
                                                   delegate:Nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

+(void)showAltView:(UIView *)altView{
    
    
}


@end

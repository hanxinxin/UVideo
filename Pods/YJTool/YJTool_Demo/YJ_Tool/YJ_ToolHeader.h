//
//  Header.h
//  YJTool_Demo
//
//  Created by yangjian on 2018/11/27.
//  Copyright © 2018 zhangshuyue. All rights reserved.
//

// 颜色的定义
#define RGB(r, g, b)  [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//读取图片
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

#import "UIView+YJExtension.h"

#import "UITableView+EmptyData.h"
#import "NSDate+YJDateExtension.h"
#import "NSString+YJStringExtension.h"

//创建view
#import "UIButton+createBtn.h"
#import "UILabel+createLabel.h"
#import "UIImageView+createImgView.h"

//image处理
#import "UIImage+Color.h"
#import "UIImage+Rotate.h"
#import "UIImage+Gif.h"
#import "UIImage+SubImage.h"
#import "UIImage+headImage.h"
#import "UIImage+YJExtension.h"

//Tool
#import "YJAllmethod.h"
#import "UILabel+YJChangeLineSpaceAndWordSpace.h"

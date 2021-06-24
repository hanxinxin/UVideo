//
//  pinglunHeaderView.h
//  video
//
//  Created by macbook on 2021/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface pinglunHeaderView : UITableViewHeaderFooterView
+ (instancetype)commentHeaderView;

/** head */
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END

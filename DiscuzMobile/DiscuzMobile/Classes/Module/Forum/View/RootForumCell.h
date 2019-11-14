//
//  RootForumCell.h
//  DiscuzMobile
//
//  Created by HB on 17/1/23.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZTreeViewNode;

@interface RootForumCell : UITableViewCell

@property (nonatomic, strong) DZTreeViewNode * node;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIButton * button;

@end

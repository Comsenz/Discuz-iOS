//
//  RootForumCell.h
//  DiscuzMobile
//
//  Created by HB on 17/1/23.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class TreeViewNode;

@interface RootForumCell : UITableViewCell

@property (nonatomic, strong) TreeViewNode * node;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIButton * button;

@end

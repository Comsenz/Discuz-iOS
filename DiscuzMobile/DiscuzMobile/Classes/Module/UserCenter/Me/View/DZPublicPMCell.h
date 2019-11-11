//
//  DZPublicPMCell.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/10/15.
//  Copyright © 2015年 comsenz-service.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZPublicPMCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contenLabel;
@property (nonatomic, strong) UILabel * timeLabel;
-(void)setdata:(NSDictionary*)dic;
@end

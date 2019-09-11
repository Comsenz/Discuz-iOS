//
//  ViewPollpotionCell.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/25.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ViewPollpotionCell;

@protocol ViewPollpotionCellDelegate <NSObject>

- (void)ViewPollpotionCellClick:(ViewPollpotionCell*)cell;

@end

@interface ViewPollpotionCell : UITableViewCell

@property (nonatomic, strong) id<ViewPollpotionCellDelegate>delegate;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton * messageBtn;
-(void)setdata:(NSDictionary*)dic;

-(CGFloat)cellheigh;

@end

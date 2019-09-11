//
//  DropDownView.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/27.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownView;

@protocol DropDownViewDelegate <NSObject>
@optional
-(void)postBtnClick:(UIButton *)btn;
- (void)postThreadClick:(NSString *)title;

@end

@interface DropDownView : UIView

@property (nonatomic ,weak) id <DropDownViewDelegate> delegate;
@property (nonatomic ,strong) NSString * fourdID;
-(id)initWithFrame:(CGRect)frame postType:(NSString*)type allowPostSpecial:(NSString *)allowpostspecial allowsPecialOnly:(NSString *)allowspecialonly;

- (id)initWithFrame:(CGRect)frame activityType:(NSMutableArray *)arr;

@end

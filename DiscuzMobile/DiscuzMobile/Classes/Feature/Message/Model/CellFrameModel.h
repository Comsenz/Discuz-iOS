//
//  CellFrameModel.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/7/6.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageModel;

#define textPadding 15

@interface CellFrameModel : NSObject

@property (nonatomic, strong) MessageModel * message;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeght;

@end

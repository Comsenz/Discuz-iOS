//
//  JTSegmentedControl.h
//  Test_Segment
//
//  Created by HB on 17/1/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTSegmentedCell,JTSegmentedControl;
@protocol JTSegmentDelegate <NSObject>

- (void)indicatorViewRelativePostion:(CGFloat)postion andSegmentControl:(JTSegmentedControl *)segmentControl;
- (void)selectedState:(JTSegmentedCell *)segmentControlCell forIndex:(NSInteger)index;
- (void)normalState:(JTSegmentedCell *)segmentControlCell forIndex:(NSInteger)index;

@end
@interface JTSegmentedControl : UIControl

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray<JTSegmentedCell *> *cells;
@property (nonatomic, assign) NSInteger defaultSelectedIndex;
@property (nonatomic, assign) BOOL isUpdateToNearestIndexWhenDrag;

@property (nonatomic, assign) NSInteger selectedIndex;  // 选中了
@property (nonatomic, assign) BOOL isScrollEnabled;
@property (nonatomic, assign) BOOL isSwipeEnabled;
@property (nonatomic, assign) BOOL isRoundedFrame;
@property (nonatomic, assign) CGFloat roundedRelativeFactor;

@property (nonatomic, weak) id<JTSegmentDelegate> delegate;
- (void)add:(JTSegmentedCell *)cell;

@end

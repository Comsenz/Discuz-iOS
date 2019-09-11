//
//  TextbarView.h
//  DiscuzMobile
//
//  Created by HB on 16/11/23.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"

@protocol TextBarDelegate <NSObject>

- (void)textBarTextChange:(CGFloat)height;

@end
typedef NS_ENUM(NSInteger, TextBarStyle) {
    thread_textBar = 0,
    chat_textBar,
    detail_textBar,
    attachment_textBar,
};

typedef NS_ENUM(NSUInteger, TextBarStatus) {
    bar_rise,
    bar_drop,
};

typedef void(^PraiseBlock)(void);
typedef void(^CollectionBlock)(UIButton *sender);
typedef void(^ShareBlock)(void);

typedef void(^ChangeKeyboard)(NSInteger tag);
typedef void(^SendMessage)(void);
typedef void(^AddBlock)(void);

@interface TextbarView : UIView

@property (nonatomic, strong) YYTextView *textView;

// ++++++++++++++++
@property (nonatomic, strong) UIView *toolContainView;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIButton *shareBtn;

// ++++++++++++++++
@property (nonatomic, strong) UIView *replyContainView;
@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, weak) id<TextBarDelegate> textBarDelegate;
@property (nonatomic, copy) ChangeKeyboard changeKeyboardBlock;
@property (nonatomic, copy) SendMessage sendMessageBlock;
@property (nonatomic, copy) AddBlock addBlock;

// ++++++++++++++++
@property (nonatomic, copy) PraiseBlock praiseBlock;
@property (nonatomic, copy) CollectionBlock collectionBlock;
@property (nonatomic, copy) ShareBlock shareBlock;

@property (nonatomic, assign) TextBarStyle style;

- (void)resetViewWithStatus:(TextBarStatus)status andTextHeight:(CGFloat)height;

@end

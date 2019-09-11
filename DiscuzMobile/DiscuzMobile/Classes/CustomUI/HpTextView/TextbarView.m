//
//  TextbarView.m
//  DiscuzMobile
//
//  Created by HB on 16/11/23.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "TextbarView.h"
#import "WBStatusComposeTextParser.h"
#import "WBStatusLayout.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface TextbarView() <YYTextViewDelegate>
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, assign) BOOL keyboardShow;
@end


@implementation TextbarView

static CGFloat btn_width = 24.0;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupViews];
    }
    return self;
}

- (void)setStyle:(TextBarStyle)style {
    _style = style;
    if (style == thread_textBar) {
        [self initTextBar];
    }
    if (style == chat_textBar) {
        [self initChatBar];
    }
    if (style == detail_textBar) {
        [self initDetailBar];
    }
    if (style == attachment_textBar) {
        [self initAttachmentBar];
    }
}

// MARK: - 帖子详情页用的表情键盘
- (void)initTextBar {
    
    [self addSubview:self.textView];
    _textView.frame = CGRectMake(8, 7, (WIDTH - 16 - 5) * 0.55, 35);
    
    self.toolContainView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + 8, CGRectGetMinY(self.textView.frame), CGRectGetWidth(self.textView.frame) * 9 / 11, CGRectGetHeight(self.textView.frame))];
    [self addSubview:self.toolContainView];
    
    
    self.praiseBtn.frame = CGRectMake(8, 6, 22, 22);
    CGFloat mm = (CGRectGetWidth(self.toolContainView.frame) - CGRectGetWidth(self.praiseBtn.frame) * 3 - btn_width) / 2;
    [self.toolContainView addSubview:self.praiseBtn];
    
    self.collectionBtn.frame = CGRectMake(CGRectGetMaxX(self.praiseBtn.frame) + mm, CGRectGetMinY(self.praiseBtn.frame), CGRectGetWidth(self.praiseBtn.frame), CGRectGetHeight(self.praiseBtn.frame));
    [self.toolContainView addSubview:self.collectionBtn];
    
    self.shareBtn.frame = CGRectMake(CGRectGetMaxX(self.collectionBtn.frame) + mm, CGRectGetMinY(self.collectionBtn.frame), CGRectGetWidth(self.collectionBtn.frame), CGRectGetHeight(self.collectionBtn.frame));
    [self.toolContainView addSubview:self.shareBtn];
    
    // 唤醒的时候
    self.replyContainView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + 8, CGRectGetMinY(self.textView.frame), 100 + 5, CGRectGetHeight(self.textView.frame))];
    [self addSubview:self.replyContainView];
    self.replyContainView.hidden = YES;
    
    
    self.faceBtn.frame = CGRectMake(8, (CGRectGetHeight(self.frame) - btn_width) / 2, btn_width, btn_width);
    [self.replyContainView addSubview:_faceBtn];
    
    [self.replyContainView addSubview:self.sendBtn];
}

- (void)initDetailBar {
    
    [self addSubview:self.textView];
    self.textView.frame = CGRectMake(8, 7, (WIDTH - 16 - 5) * 0.55, 35);
    
    self.toolContainView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + 8, CGRectGetMinY(self.textView.frame), CGRectGetWidth(self.textView.frame) * 9 / 11, CGRectGetHeight(self.textView.frame))];
    [self addSubview:self.toolContainView];
    
    self.praiseBtn.frame = CGRectMake(8, 6, 22, 22);
    CGFloat mm = (CGRectGetWidth(self.toolContainView.frame) - CGRectGetWidth(self.praiseBtn.frame) * 3 - btn_width) / 2;
    [self.toolContainView addSubview:self.praiseBtn];
    
    self.collectionBtn.frame = CGRectMake(CGRectGetMaxX(self.praiseBtn.frame) + mm, CGRectGetMinY(self.praiseBtn.frame), CGRectGetWidth(self.praiseBtn.frame), CGRectGetHeight(self.praiseBtn.frame));
    [self.toolContainView addSubview:self.collectionBtn];
    
    self.shareBtn.frame = CGRectMake(CGRectGetMaxX(self.collectionBtn.frame) + mm, CGRectGetMinY(self.collectionBtn.frame), CGRectGetWidth(self.collectionBtn.frame), CGRectGetHeight(self.collectionBtn.frame));
    [self.toolContainView addSubview:self.shareBtn];
    
    
    if (![ShareSDK isClientInstalled:SSDKPlatformTypeWechat] && ![ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        [self.shareBtn setHidden:YES];
        self.praiseBtn.frame = CGRectMake(30, 6, 22, 22);
        self.collectionBtn.frame = CGRectMake(CGRectGetMaxX(self.praiseBtn.frame) + mm, CGRectGetMinY(self.praiseBtn.frame), CGRectGetWidth(self.praiseBtn.frame), CGRectGetHeight(self.praiseBtn.frame));
    }
    
    // 唤醒的时候
    self.replyContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 100 + 5, CGRectGetHeight(self.textView.frame))];
    self.replyContainView.hidden = YES;
    
    
    self.faceBtn.frame = CGRectMake(5, 12, btn_width, btn_width);
    [self.faceBtn setHidden:YES];
    [self addSubview:_faceBtn];
    
    self.addBtn.frame = CGRectMake(CGRectGetMaxX(_faceBtn.frame) + 10, 12, btn_width, btn_width);
    self.addBtn.hidden = YES;
    [self addSubview:self.addBtn];
    
    self.sendBtn.frame = CGRectMake(CGRectGetMaxX(_textView.frame)  + 10, 7, 50, 32);
    self.sendBtn.hidden = YES;
    [self addSubview:self.sendBtn];
}

- (void)initAttachmentBar {
    
    [self addSubview:self.faceBtn];
    [self addSubview:self.addBtn];
    [self addSubview:self.textView];
    [self addSubview:self.sendBtn];
    
    self.faceBtn.frame = CGRectMake(5, 12, btn_width, btn_width);
    self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.faceBtn.frame) + 10, 12, btn_width, btn_width);
    self.textView.frame = CGRectMake(btn_width * 2 + 25, 7, WIDTH - (btn_width * 2 + 25)  - 70, 35);
    self.sendBtn.frame = CGRectMake(CGRectGetMaxX(_textView.frame)  + 10, 7, 50, 32);
    
    
}

// MARK: - 消息详情页用的表情键盘
- (void)initChatBar {
    
    
    self.textView.placeholderText = @"回复消息";
    [self addSubview:self.textView];
    
    // 唤醒的时候
    self.replyContainView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame), CGRectGetMinY(self.textView.frame), 110 + 5, CGRectGetHeight(self.textView.frame))];
    [self addSubview:self.replyContainView];
    
    
    self.faceBtn.frame = CGRectMake(10, 4, btn_width, btn_width);
    [self.replyContainView addSubview:self.faceBtn];
    
    [self.replyContainView addSubview:self.sendBtn];
}

// MARK: - 帖子详情页键盘升起和降下修改textbar
- (void)resetViewWithStatus:(TextBarStatus)status andTextHeight:(CGFloat)height{
    if (status == bar_rise) { // 键盘升起
        if (self.style == detail_textBar) {
            self.keyboardShow = YES;
           
            self.faceBtn.frame = CGRectMake(5, 12, btn_width, btn_width);
            self.addBtn.frame = CGRectMake(CGRectGetMaxX(_faceBtn.frame) + 10, 12, btn_width, btn_width);
            self.textView.frame = CGRectMake(btn_width * 2 + 25, 7, WIDTH - (btn_width * 2 + 25)  - 70, height);
            self.sendBtn.frame = CGRectMake(CGRectGetMaxX(_textView.frame)  + 10, 7, 50, 32);
            self.toolContainView.hidden = YES;
            self.faceBtn.hidden = NO;
            self.addBtn.hidden = NO;
            self.sendBtn.hidden = NO;
            
        } else {
            
            self.keyboardShow = YES;
            self.toolContainView.hidden = YES;
            self.replyContainView.hidden = NO;
            self.textView.frame = CGRectMake(8, 7, WIDTH - 8 - btn_width - 32  - 60, height);
            self.replyContainView.frame = CGRectMake(CGRectGetMaxX(_textView.frame), CGRectGetMinY(self.textView.frame), 100 + 5, 35);
        }
        
    } else if (status == bar_drop) {
        
        if (self.style == detail_textBar) {
            
            self.faceBtn.hidden = YES;
            self.addBtn.hidden = YES;
            self.sendBtn.hidden = YES;
        }
        
        self.keyboardShow = NO;
        self.toolContainView.hidden = NO;
        self.replyContainView.hidden = YES;
        self.textView.frame = CGRectMake(8, 7, (WIDTH - 16 - 5) * 0.55, height);
        self.toolContainView.frame = CGRectMake(CGRectGetMaxX(_textView.frame) + 8, CGRectGetMinY(self.textView.frame), CGRectGetWidth(self.textView.frame) * 9 / 11, 35);
    }
}

- (void)p_setupViews {
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    UIImage * rawBackground = [UIImage imageNamed:@"chatkeyboardbg.png"];
    UIImage * background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    _backgroundView = [[UIImageView alloc] initWithImage:background];
    _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_backgroundView];
}

// MARK: - 表情切换
- (void)resignText:(UIButton *)sender {
    if (self.changeKeyboardBlock) {
        self.changeKeyboardBlock(sender.tag);
    }
}

// MARK: - 发送
- (void)send {
    if (self.sendMessageBlock) {
        self.sendMessageBlock();
    }
}

// MARK: - 赞一个
- (void)praise {
    if (self.praiseBlock) {
        self.praiseBlock();
    }
}

// MARK: - 收藏
- (void)collection:(UIButton *)sender {
    if (self.collectionBlock) {
        self.collectionBlock(sender);
    }
}

// MARK: - 分享
- (void)share {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

// 懒加载
- (YYTextView *)textView {
    if (_textView == nil) {
        _textView = [YYTextView new];
        _textView.frame = CGRectMake(8, 7, WIDTH - 8 - 20 - 40  - 60, 35);
        _textView.extraAccessoryViewHeight = 140;
        _textView.showsVerticalScrollIndicator = YES;
        _textView.alwaysBounceVertical = YES;
        _textView.allowsCopyAttributedString = NO;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.textParser = [WBStatusComposeTextParser new];
        _textView.delegate = self;
        _textView.inputAccessoryView = [UIView new];
        
        _textView.returnKeyType = UIReturnKeyDefault; //just as an example
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textView.backgroundColor = MAIN_GRAY_COLOR;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 17;
        
//        WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
//        modifier.font = [UIFont fontWithName:@"Heiti SC" size:15];
//        modifier.paddingTop = 12;
//        modifier.paddingBottom = 12;
//        modifier.lineHeightMultiple = 1.5;
//        _textView.linePositionModifier = modifier;
        
        _textView.placeholderText = @"写评论...";
    }
    return _textView;
}

- (void)textViewDidChange:(YYTextView *)textView {
    
    CGFloat textH = [self measureHeight];
    CGFloat h = textH > 35 ? textH : 35;
    CGRect oRect = textView.frame;
    CGFloat addH = h - oRect.size.height;
    
    if (h < 140) {
        oRect.size.height = h;
        self.textView.frame = oRect;
        CGRect barFrame = self.frame;
        barFrame.size.height += addH;
        self.frame = barFrame;
        if ([self.textBarDelegate respondsToSelector:@selector(textBarTextChange:)]) {
            [self.textBarDelegate textBarTextChange:addH];
        }
    }
    if (h >= 140) {
        [self resetScrollPosition];
    }
    if ([DataCheck isValidString:textView.text]) {
        self.sendBtn.enabled = YES;
    } else {
        self.sendBtn.enabled = NO;
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text hasEmoji]) {
        return NO;
    }
    return YES;
    
}

- (void)resetScrollPosition {
    CGRect r = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
    CGFloat caretY =  MAX(r.origin.y - self.textView.frame.size.height + r.size.height + 8, 0);
    if (self.textView.contentOffset.y < caretY && r.origin.y != INFINITY)
        self.textView.contentOffset = CGPointMake(0, caretY);
}

- (CGFloat)measureHeight {
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        return ceilf([self.textView sizeThatFits:self.textView.frame.size].height);
    }
    else {
        return self.textView.contentSize.height;
    }
}

- (UIButton *)sendBtn {
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"跟帖" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _sendBtn.titleLabel.textColor = [UIColor whiteColor];
        _sendBtn.frame = CGRectMake(CGRectGetMaxX(_faceBtn.frame)  + 10, 3, 60, 32);
        [_sendBtn setBackgroundImage:[UIImage imageWithColor:DISABLED_COLOR] forState:UIControlStateDisabled];
        [_sendBtn setBackgroundImage:[UIImage imageWithColor:MAINCOLOR] forState:UIControlStateNormal];
        _sendBtn.enabled = NO;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 15;
        [_sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)praiseBtn {
    if (_praiseBtn == nil) {
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setBackgroundImage:[UIImage imageNamed:@"bar_zan"] forState:UIControlStateNormal];
        _praiseBtn.cs_acceptEventInterval = 1;
        [_praiseBtn addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseBtn;
}

- (UIButton *)collectionBtn {
    if (_collectionBtn == nil) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"bar_xing"] forState:UIControlStateNormal];
        _collectionBtn.tag = 100001;
        _collectionBtn.cs_acceptEventInterval = 1;
        [_collectionBtn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}

- (UIButton *)shareBtn {
    if (_shareBtn == nil) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"bar_fen"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.cs_acceptEventInterval = 1;
    }
    return _shareBtn;
}

- (UIButton *)faceBtn {
    
    if (_faceBtn == nil) {
        _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceBtn.tag = 101;
        [_faceBtn addTarget:self action:@selector(resignText:) forControlEvents:UIControlEventTouchUpInside];
        [_faceBtn setBackgroundImage:[UIImage imageNamed:@"chat_emo"] forState:UIControlStateNormal];
    }
    return _faceBtn;
}

- (UIButton *)addBtn {
    
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.tag = 102;
        [_addBtn addTarget:self action:@selector(resignText:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"add_attachment"] forState:UIControlStateNormal];
    }
    
    return _addBtn;
}


@end

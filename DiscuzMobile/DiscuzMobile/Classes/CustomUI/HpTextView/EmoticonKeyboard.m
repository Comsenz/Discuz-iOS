//
//  EmoticonKeyboard.m
//  DiscuzMobile
//
//  Created by HB on 16/11/28.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "EmoticonKeyboard.h"
#import "WBEmoticonInputView.h"

static const NSInteger RowFaceCount = 9;

@interface EmoticonKeyboard() <WBStatusComposeEmoticonViewDelegate,TextBarDelegate>
{
    CGFloat toolBarHeight;
    CGFloat keyboardHeight;
    CGFloat emotionVHeight;
    CGFloat TextBarHeight;
    CGFloat SCHeight;
}
// 键盘属性
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) BOOL isSwitch;
@end
@implementation EmoticonKeyboard

@synthesize imageboaudIsShow;  // 自定义表情可见
@synthesize textBarView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
        
        toolBarHeight = 40;
        keyboardHeight = 216;
        emotionVHeight = 0;
        TextBarHeight = 50;
        SCHeight = 0;
        
        [self initKeyboardComponment];
        
    }
    return self;
}

- (void)dealloc {
    DLog(@"键盘对象销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initKeyboardComponment {
    if (WIDTH > 414) {
        CGFloat height = WIDTH  / (RowFaceCount + 0.5) * 4;
        keyboardHeight = height;
    }
    
    SCHeight = HEIGHT - SafeAreaBottomHeight;
    
    emotionVHeight = keyboardHeight - toolBarHeight;
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), WIDTH, keyboardHeight)];
    /*******************这里设置可以定义键盘更多东西************************************/
    self.contentView.contentSize = CGSizeMake(WIDTH * 2, 1);
    self.contentView.pagingEnabled = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.scrollEnabled = NO;
    /*******************************************************/
    [self addSubview:self.contentView];
    
    [self setTextBar];
    [self setEmoticonBoard];
    [self setAttachmentBar];
    [self setUploadImageView];
}

// 输入框
- (void)setTextBar {
    self.ChangeHeight = 0;
    // 创建回复栏
    textBarView = [[TextbarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, TextBarHeight)];
    textBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    imageboaudIsShow = NO;
    WEAKSELF;
    
    textBarView.changeKeyboardBlock = ^(NSInteger tag) {
        [weakSelf resignTextView:tag];
    };
    textBarView.textBarDelegate = self;
    
    [self addSubview:textBarView];
}

- (void)textBarTextChange:(CGFloat)height {
   
    CGRect tempRect = self.frame;
    tempRect.origin.y -= height;
    tempRect.size.height += height;
    self.frame = tempRect;
    
    CGRect textbarRect = textBarView.frame;
    self.textBarView.frame = CGRectMake(0, 0, WIDTH, textbarRect.size.height);
    
    if (imageboaudIsShow) {
        self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - keyboardHeight,WIDTH, keyboardHeight);
        
    }
    
    WBEmoticonInputView *v = [WBEmoticonInputView sharedView];
    v.frame = CGRectMake(0, CGRectGetHeight(textBarView.frame), WIDTH, keyboardHeight);
    
    self.ChangeHeight = self.textBarView.frame.size.height - TextBarHeight;
    
    if (self.changeBlock) {
        self.changeBlock(height, self.ChangeHeight);
    }
}

// 表情图片
- (void)setEmoticonBoard {
    
    WBEmoticonInputView *v = [WBEmoticonInputView sharedView];
    v.frame = CGRectMake(0, CGRectGetHeight(textBarView.frame), WIDTH, keyboardHeight);
    v.hidden = YES;
    v.delegate = self;
    [self addSubview:v];

}

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [textBarView.textView replaceRange:textBarView.textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [textBarView.textView deleteBackward];
}


- (void)setAttachmentBar {
    self.attachmentBar = [[AttachmentBar alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, 44)];
    self.attachmentBar.layer.borderColor = LINE_COLOR.CGColor;
    self.attachmentBar.layer.borderWidth = 0.8;
    [self.contentView addSubview:self.attachmentBar];
}

- (void)setUploadImageView {
    [self setupPickerView];
}

- (void)setupPickerView {
    self.uploadView = [[UploadAttachView alloc] initWithFrame:CGRectMake(WIDTH, CGRectGetHeight(self.attachmentBar.frame), WIDTH, keyboardHeight - CGRectGetHeight(self.attachmentBar.frame))];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.uploadView];
}


- (void)keyboardShow:(NSNotification *)note {
    
    if (![self hu_intersectsWithAnotherView:nil]) {
        return;
    }
    
    self.currentTag = 0;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) { // 待激活状态和后台状态
        return;
    }
    
    [textBarView.faceBtn setBackgroundImage:[UIImage imageNamed:@"chat_emo"] forState:UIControlStateNormal];
    
    if (self.keyboardShowBlock) {
        self.keyboardShowBlock();
    }
    
    if (imageboaudIsShow) {
        [WBEmoticonInputView sharedView].hidden = YES;
    }
    imageboaudIsShow = NO;
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.superview convertRect:keyboardBounds toView:nil];

    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.frame = CGRectMake(0, HEIGHT - (keyboardBounds.size.height + TextBarHeight + self.ChangeHeight), WIDTH, keyboardBounds.size.height + TextBarHeight + self.ChangeHeight);
    self.textBarView.frame = CGRectMake(0, 0, WIDTH, TextBarHeight + self.ChangeHeight);
    self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.frame), WIDTH, keyboardHeight);
    
    [UIView commitAnimations];
    
}


- (void)keyboardHide:(NSNotification *)note {
    
    if (![self hu_intersectsWithAnotherView:nil]) {
        return;
    }
    
    if (imageboaudIsShow) {
        
        if (self.isSwitch) { // 点击表情切换按钮后，已经处理过了不让它处理frame
            
            self.isSwitch = NO;
        } else {
            imageboaudIsShow = NO;
            [WBEmoticonInputView sharedView].hidden = YES;
            [UIView animateWithDuration:BShowTime animations:^{
                self.frame = CGRectMake(0, SCHeight - (keyboardHeight + TextBarHeight + self.ChangeHeight), WIDTH, keyboardHeight + TextBarHeight + self.ChangeHeight);
                CGRect textbarRect = textBarView.frame;
                self.textBarView.frame = CGRectMake(0, 0, WIDTH, textbarRect.size.height);
                self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - keyboardHeight,WIDTH, keyboardHeight);
            }];
        }
        
    } else {
        
        [UIView animateWithDuration:BShowTime animations:^{
            self.frame = CGRectMake(0, SCHeight - CGRectGetHeight(self.textBarView.frame), WIDTH, CGRectGetHeight(self.textBarView.frame));
            textBarView.frame = CGRectMake(0, 0, WIDTH, CGRectGetHeight(textBarView.frame));
            self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.frame),WIDTH, keyboardHeight);
        }];
    }
}

- (void)hideCustomerKeyBoard {
    self.currentTag = 0;
    [self.textBarView.textView resignFirstResponder];
    [textBarView.faceBtn setBackgroundImage:[UIImage imageNamed:@"chat_emo"] forState:UIControlStateNormal];
    CGRect containerFrame = self.frame;
    containerFrame.origin.y = SCHeight - CGRectGetHeight(self.textBarView.frame);
    
    [UIView animateWithDuration:BShowTime animations:^{
        self.frame = CGRectMake(0, CGRectGetMinY(containerFrame), WIDTH, CGRectGetHeight(self.textBarView.frame));
        self.textBarView.frame = CGRectMake(0, 0, WIDTH, CGRectGetHeight(self.textBarView.frame));
    }];
    
    if (self.keyboardHideBlock) {
        self.keyboardHideBlock();
    }
    
    imageboaudIsShow = NO;
    [WBEmoticonInputView sharedView].hidden = YES;
    self.contentView.contentOffset = CGPointMake(0, 0);
}

// 表情切换
-(void)resignTextView:(NSInteger)tag {
    
    self.isSwitch = YES;
    
    if (!imageboaudIsShow) { // 使自定义表情出现
        imageboaudIsShow = YES;  // 必须 如：第一次直接点击表情时
        WBEmoticonInputView *v = [WBEmoticonInputView sharedView];
        if ([v superview] == nil) {
            [self addSubview:v];
            v.delegate = self;
        }
        v.hidden = NO;
        if (self.textBarView.style == detail_textBar || self.textBarView.style == attachment_textBar) {
            [self detailkeyBoardDeal:tag];
            if ([self detailIsReturn:tag]) {
                return;
            }
            self.currentTag = tag;
        }
        
        if (tag == 101) {
            [textBarView.faceBtn setBackgroundImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        }
        
        [textBarView.textView resignFirstResponder];
        
        // 表情键盘没有显示     则显示表情键盘   取消 textView  的第一响应
        CGFloat selfheight = keyboardHeight + TextBarHeight + self.ChangeHeight;
        
        [UIView animateWithDuration:BShowTime animations:^{
            self.frame = CGRectMake(0, SCHeight - selfheight, WIDTH, selfheight);
            self.textBarView.frame = CGRectMake(0, 0,  WIDTH,TextBarHeight + self.ChangeHeight);
            self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - keyboardHeight,WIDTH, keyboardHeight);
            v.frame = CGRectMake(0, CGRectGetHeight(textBarView.frame), WIDTH, keyboardHeight);
        }];
        
        if (self.showBlock) {
            self.showBlock(CGRectGetHeight(self.frame));
        }
        
    } else { // 使系统键盘出现
        if (self.textBarView.style == detail_textBar || self.textBarView.style == attachment_textBar) {
            [self detailkeyBoardDeal:tag];
            if ([self detailIsReturn:tag]) {
                return;
            }
            self.currentTag = 0;
        }
        
        [textBarView.textView becomeFirstResponder]; // 键盘响应之后  下面控制 高度
    }
}

- (BOOL)detailIsReturn:(NSInteger)tag {
    if (self.currentTag != tag && self.currentTag != 0) {
        self.currentTag = tag;
        return YES;
    }
    return NO;
}


- (void)detailkeyBoardDeal:(NSInteger)tag {
    if (tag == 101) {
        
        [textBarView.faceBtn setBackgroundImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [WBEmoticonInputView sharedView].hidden = NO;
        self.contentView.contentOffset = CGPointMake(0, 0);
        
    } else if (tag == 102) {
        [textBarView.faceBtn setBackgroundImage:[UIImage imageNamed:@"chat_emo"] forState:UIControlStateNormal];
        [WBEmoticonInputView sharedView].hidden = YES;
        self.contentView.contentOffset = CGPointMake(WIDTH, 0);
        
    }
}


- (void)clearData {
    textBarView.textView.text = @"";
    if (self.uploadView.uploadModel.aidArray.count > 0) {
        [self.uploadView.uploadModel.aidArray removeAllObjects];
        [self.uploadView.uploadModel.photosArray removeAllObjects];
        [self.uploadView.uploadModel.imageModelArray removeAllObjects];
        
        [self.uploadView.pickerView.photosArray removeAllObjects];
        [self.uploadView.pickerView refreshCollectionView];
    }
}

- (NSMutableArray *)faceArray {
    if (!_faceArray) {
        _faceArray = [NSMutableArray array];
    }
    return _faceArray;
}
- (NSMutableArray *)imageNameArr {
    if (!_imageNameArr) {
        _imageNameArr = [NSMutableArray array];
    }
    return _imageNameArr;
}

@end

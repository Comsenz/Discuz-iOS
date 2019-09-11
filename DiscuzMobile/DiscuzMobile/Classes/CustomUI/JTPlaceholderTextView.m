//
//  JTPlaceholderTextView.h
//  DiscuzMobile
//
//  Created by HB on 16/12/1.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "JTPlaceholderTextView.h"

@implementation JTPlaceholderTextView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholderColor = mRGBColor(211, 211, 211);
//        [self commitInit];
        // 在通知中心为TextView注册一个当文本改变的通知，当文本发生变化时，TextView会发一个通知
        // iOS 注册接收通知的方式为：addObserver name:
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textHasChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)commitInit {
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fix,doneButton, nil]];
    self.inputAccessoryView = keyboardDoneButtonView;
}

- (void)doneClicked:(UIBarButtonItem *)sender {
    [self resignFirstResponder];
}

// 当文字改变时会调用此方法
- (void)textHasChange {
    
    // setNeedsDisplay 向操作系统发出请求重绘的消息
    // 操作系统会在未来的时间内调用drawRect(iOS),onDraw(android);
    // 注意：系统不允许我们自己调用drawRect或onDraw方法
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    
    if ([self hasText]) return; // 如果检测到当前TextView中有文本，就不再绘制
    
    CGFloat placeholderRectX = 5;
    CGFloat placeholderRectY = 8;
    CGFloat placeholderRectW = rect.size.width - 2 * placeholderRectX;
    CGFloat placeholderRectH = rect.size.height - 2 * placeholderRectY;
    
    
    // 将文本绘制在一个指定的矩形框内
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    // 若用户没有设置placeholder的颜色，则给placeholder设置一个默认颜色
    attrs[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor grayColor];
    [self.placeholder drawInRect:CGRectMake(placeholderRectX, placeholderRectY, placeholderRectW, placeholderRectH) withAttributes:attrs];
    
    
}

#pragma mark - 当用户手动更新当前字体属性时，就自动触发重绘
- (void)setText:(NSString *)text{
    
    [super setText:text];
    [self setNeedsDisplay];
    
}


- (void)setFont:(UIFont *)font {
    
    [super setFont:font];
    [self setNeedsDisplay];
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    [self setNeedsDisplay];
    
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
    
}

- (void)dealloc {
    
    // 销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



@end

//
//  MessageModel.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/7/6.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "MessageModel.h"
#import "NSMutableAttributedString+JsEmotion.h"

@implementation MessageModel

+ (id)messageModelWithDict:(NSDictionary *)dict
{
    MessageModel * message = [[self alloc] init];
    message.text = [dict[@"message"] transformationStr];
    message.authorid = dict[@"msgfromid"];

    message.time = [dict objectForKey:@"vdateline"];
    message.type = [dict objectForKey:@"type"];
    message.plid = [dict objectForKey:@"plid"];
    message.pmid = [dict objectForKey:@"pmid"];
    message.touid = [dict objectForKey:@"touid"];
    message.fromavatar = [dict objectForKey:@"fromavatar"];
    message.toavatar = [dict objectForKey:@"toavatar"];

    return message;
}

- (void)setText:(NSString *)text {
    
    _text = text;
    
    CGFloat textWidth = 250.0;
    UIFont *fontSize = [FontSize HomecellNameFontSize16];
    
    NSMutableString *string = text.mutableCopy;
    NSMutableAttributedString *textstr = [[NSMutableAttributedString alloc] initWithString:string];
    textstr.font = fontSize;
    textstr.color = MAIN_TITLE_COLOR;
    
    [textstr emotionFontsize:16.0f];
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = fontSize;
    modifier.lineHeightMultiple = 1.8;
    modifier.paddingTop = 0;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(textWidth, HUGE);
    container.linePositionModifier = modifier;
    
    self.commentAttributeText = textstr;
    _textLayout = [YYTextLayout layoutWithContainer:container text:textstr];
    if (!_textLayout) return;
    CGFloat textHeight = [modifier heightForLineCount:_textLayout.rowCount];
    self.textHeight = textHeight;
}

@end

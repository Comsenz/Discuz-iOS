//
//  NSMutableAttributedString+JsEmotion.m
//  Jinsanjiao
//
//  Created by ZhangJitao on 2018/5/18.
//  Copyright © 2018年 17keji.com. All rights reserved.
//

#import "NSMutableAttributedString+JsEmotion.h"
#import "WBStatusLayout.h"

@implementation NSMutableAttributedString (JsEmotion)

- (NSMutableAttributedString *)emotionFontsize:(CGFloat)fontSize {
    // 匹配 [表情]
    NSArray<NSTextCheckingResult *> *emoticonResults = [[WBStatusHelper regexEmoticon] matchesInString:self.string options:kNilOptions range:self.rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([self attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([self attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [self.string substringWithRange:range];
        NSString *imagePath = [WBStatusHelper emoticonDic][emoString];
        UIImage *image = [WBStatusHelper imageWithPath:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:fontSize];
        [self replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    return self;
}

@end

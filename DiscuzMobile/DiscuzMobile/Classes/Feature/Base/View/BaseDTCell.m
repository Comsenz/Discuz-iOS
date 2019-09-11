//
//  BaseDTCell.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/12.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "BaseDTCell.h"
#import "DTWebVideoView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BaseDTCell() <DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
@end

@implementation BaseDTCell {
    DTAttributedTextContentView *_attributedTextContextView;
    NSUInteger _htmlHash; // preserved hash to avoid relayouting for same HTML
    BOOL _hasFixedRowHeight;
}
@synthesize attributedTextContextView = _attributedTextContextView;
@synthesize hasFixedRowHeight = _hasFixedRowHeight;
@synthesize mediaPlayers;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.webImageArray removeAllObjects];
    }
    return self;
}

- (void)dealloc {
    for (MPMoviePlayerController *player in self.mediaPlayers) {
        [player stop];
    }
}

- (void)setHTMLString:(NSString *)html options:(NSDictionary*) options {
    
    NSUInteger newHash = [html hash];
    if (newHash == _htmlHash) {
        return;
    }
    _htmlHash = newHash;
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    //    NSString *cssSheet = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //    DTCSSStylesheet *mainCss = [[DTCSSStylesheet alloc] initWithStyleBlock:cssSheet];
    //    [[DTCSSStylesheet defaultStyleSheet] mergeStylesheet:mainCss];
    DTCSSStylesheet *baseCss = [[DTCSSStylesheet alloc] initWithStyleBlock:@"html{color:#333;line-height:20px;}"];
    DTCSSStylesheet *videoCss = [[DTCSSStylesheet alloc] initWithStyleBlock:[NSString stringWithFormat:@"video{width:%fpx:;height:height:%fpx;display:block;}",WIDTH - 20,(WIDTH - 20) * 0.75]];
    DTCSSStylesheet *iframeCss = [[DTCSSStylesheet alloc] initWithStyleBlock:[NSString stringWithFormat:@"iframe{width:%fpx:;height:%fpx;display:block;}",WIDTH - 20,(WIDTH - 20) * 0.75]];
    [[DTCSSStylesheet defaultStyleSheet] mergeStylesheet:baseCss];
    [[DTCSSStylesheet defaultStyleSheet] mergeStylesheet:videoCss];
    [[DTCSSStylesheet defaultStyleSheet] mergeStylesheet:iframeCss];
    
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *muString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL].mutableCopy;
    NSRange allRange = {0,[muString length]};
    [muString addAttribute:NSFontAttributeName value:[FontSize HomecellTitleFontSize15] range:allRange];
    
    self.attributedString = muString;
    [self setNeedsLayout];
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    
    if ([attachment isKindOfClass:[DTVideoTextAttachment class]]) {
        NSURL *url = (id)attachment.contentURL;
        UIView *grayView = [[UIView alloc] initWithFrame:frame];
        // we could customize the view that shows before playback starts
        if (frame.size.width < WIDTH) {
            grayView.frame = frame;
        } else {
            grayView.frame = CGRectMake(frame.origin.x, frame.origin.y, WIDTH - 50, frame.size.height * ((WIDTH  - 50)/ frame.size.width));
        }
        grayView.backgroundColor = [DTColor blackColor];
        
        // find a player for this URL if we already got one
        MPMoviePlayerController *player = nil;
        for (player in self.mediaPlayers) {
            if ([player.contentURL isEqual:url]) {
                break;
            }
        }
        
        if (!player) {
            player = [[MPMoviePlayerController alloc] initWithContentURL:url];
            [self.mediaPlayers addObject:player];
        }
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_2
        NSString *airplayAttr = [attachment.attributes objectForKey:@"x-webkit-airplay"];
        if ([airplayAttr isEqualToString:@"allow"]) {
            if ([player respondsToSelector:@selector(setAllowsAirPlay:)]) {
                player.allowsAirPlay = YES;
            }
        }
#endif
        NSString *controlsAttr = [attachment.attributes objectForKey:@"controls"];
        if (controlsAttr) {
            player.controlStyle = MPMovieControlStyleEmbedded;
        }
        else {
            player.controlStyle = MPMovieControlStyleNone;
        }
        
        NSString *loopAttr = [attachment.attributes objectForKey:@"loop"];
        if (loopAttr) {
            player.repeatMode = MPMovieRepeatModeOne;
        }
        else {
            player.repeatMode = MPMovieRepeatModeNone;
        }
        
        NSString *autoplayAttr = [attachment.attributes objectForKey:@"autoplay"];
        if (autoplayAttr) {
            player.shouldAutoplay = YES;
        }
        else {
            player.shouldAutoplay = NO;
        }
        
        [player prepareToPlay];
        player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        player.view.frame = grayView.bounds;
        [grayView addSubview:player.view];
        
        return grayView;
        
    } else if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.userInteractionEnabled = YES;
        imageView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webImageClick:)];
        [imageView addGestureRecognizer:tap];
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        [self.webImageArray addObject:attachment.contentURL.absoluteString];
        // url for deferred loading
        imageView.url = attachment.contentURL;
        return imageView;
        
    } else if ([attachment isKindOfClass:[DTIframeTextAttachment class]]) {
        DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
        videoView.attachment = attachment;
        videoView.backgroundColor = [UIColor redColor];
        return videoView;
        
    } else if ([attachment isKindOfClass:[DTObjectTextAttachment class]]) {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    
    return nil;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame {
    DTLinkButton *linkBtn = [[DTLinkButton alloc] initWithFrame:frame];
    linkBtn.URL = url;
    linkBtn.GUID = identifier;
    linkBtn.minimumHitSize = CGSizeMake(25, 25);
    [linkBtn addTarget:self action:@selector(linkDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return linkBtn;
}

- (void)linkDidClick:(DTLinkButton *)linkButton {
    DLog(@"%@",linkButton.URL);
    if ([self.webClickDelegate respondsToSelector:@selector(linkDidClick:)]) {
        [self.webClickDelegate linkDidClick:linkButton.URL.absoluteString];
    }
    
}

- (void)webImageClick:(UITapGestureRecognizer *)sender {
    if (self.webImageArray.count > 0) {
        DTLazyImageView *lazyImageView = (DTLazyImageView *)sender.view;
        NSInteger index = [self.webImageArray indexOfObject:lazyImageView.url.absoluteString];
        if ([self.webClickDelegate respondsToSelector:@selector(webImageClick:index:)]) {
            [self.webClickDelegate webImageClick:lazyImageView.url.absoluteString index:index];
        }
        DLog(@"点击图片:%@, 顺序：%ld",lazyImageView.url,index);
    }
}

#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [self.attributedTextContextView.layoutFrame textAttachmentsWithPredicate:pred]) {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero)) {
            if (imageSize.width > WIDTH) {
                CGFloat width = imageSize.width;
                imageSize.height = (WIDTH - 20) / width * (imageSize.height);
                imageSize.width = WIDTH - 20;
                
            }
            oneAttachment.originalSize = imageSize;
            didUpdate = YES;
        }
    }
    if (didUpdate) {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            // here we're layouting the entire string, might be more efficient to only relayout the paragraphs that contain these attachments
            self.attributedTextContextView.layouter=nil;
            [self.attributedTextContextView relayoutText];
            [self setNeedsLayout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDTable" object:nil];
        });
    }
}

#pragma mark - getter
- (DTAttributedTextContentView *)attributedTextContextView {
    if (!_attributedTextContextView) {
        _attributedTextContextView = [[DTAttributedTextContentView alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, CGRectGetHeight(self.contentView.frame) - 10)];
        _attributedTextContextView.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _attributedTextContextView.layoutFrameHeightIsConstrainedByBounds = _hasFixedRowHeight;
        _attributedTextContextView.delegate = self;
        _attributedTextContextView.shouldDrawImages = YES;
        [self.contentView addSubview:_attributedTextContextView];
    }
    
    return _attributedTextContextView;
}

- (void)setHasFixedRowHeight:(BOOL)hasFixedRowHeight {
    if (_hasFixedRowHeight != hasFixedRowHeight) {
        _hasFixedRowHeight = hasFixedRowHeight;
        [self setNeedsLayout];
    }
}

- (NSMutableArray *)webImageArray {
    if (!_webImageArray) {
        _webImageArray = [NSMutableArray array];
    }
    return _webImageArray;
}

#pragma mark Properties
- (NSMutableSet *)mediaPlayers {
    if (!mediaPlayers)
    {
        mediaPlayers = [[NSMutableSet alloc] init];
    }
    
    return mediaPlayers;
}

@end

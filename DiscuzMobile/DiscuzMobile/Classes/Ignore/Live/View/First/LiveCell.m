//
//  LiveCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/5.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveCell.h"
#import "HotLivelistModel.h"
#import "LiveRecommentView.h"
#import "BannerImageView.h"
#import "JudgeImageModel.h"

@interface LiveCell()

@property (nonatomic, strong) NSMutableArray<HotLivelistModel *> *imageArr;
@property (nonatomic, strong) UIView *sepView;

@end

@implementation LiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.sepView];
}


- (UIView *)sepView {
    if (_sepView == nil) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _sepView;
}

- (void)setImageArr:(NSMutableArray<HotLivelistModel *> *)imageArr {
    _imageArr = imageArr;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [self.contentView addSubview:self.sepView];
    
    NSString *phImageStr = @"live_p1";
    if (self.imageArr.count == 2) {
        phImageStr = @"live_p2";
    } else if (self.imageArr.count >= 3) {
        phImageStr = @"live_p3";
    }
    
    CGFloat space = 10;
    CGFloat view_width = (WIDTH - space * (self.imageArr.count + 1)) / self.imageArr.count;
    
    if (self.imageArr.count > 1) {
        __block UIView *tepView = self.contentView;
        [self.imageArr enumerateObjectsUsingBlock:^(HotLivelistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LiveRecommentView *liveView = [[LiveRecommentView alloc] init];
            
            NSString *tempStr = [obj.liveIcon makeDomain];
            liveView.picView.image = [UIImage imageNamed:phImageStr];
            if ([JudgeImageModel graphFreeModel] == NO) {
                
                [liveView.picView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:phImageStr] options:SDWebImageRetryFailed];
            }
            
            liveView.titleLab.text = obj.subject;
            liveView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setClickRecomment:)];
            liveView.tag = idx;
            [self.contentView addSubview:liveView];
            [liveView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if ([tepView isKindOfClass:[LiveRecommentView class]]) {
                    make.left.equalTo(tepView.mas_right).offset(space);
                } else {
                    make.left.equalTo(tepView).offset(space);
                }
                make.top.mas_equalTo(space);
                make.width.mas_equalTo(view_width);
                make.height.equalTo(self).valueOffset(@-18);
            }];
            [liveView addGestureRecognizer:tap];
            tepView = liveView;
        }];
    } else if (self.imageArr.count == 1){
        
        HotLivelistModel *model = self.imageArr[0];
        BannerImageView *banner = [[BannerImageView alloc] init];
        banner.titleLabel.text = model.subject;
        NSString *tempStr = [model.liveIcon makeDomain];
        banner.backgroundColor = [UIColor groupTableViewBackgroundColor];
        banner.image = [UIImage imageNamed:phImageStr];
        if ([JudgeImageModel graphFreeModel] == NO) {
            [banner sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:phImageStr] options:SDWebImageRetryFailed];
        }
        
        banner.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setClickRecomment:)];
        banner.tag = 0;
        [banner addGestureRecognizer:tap];
        [self.contentView addSubview:banner];
        [banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.width.mas_equalTo(WIDTH);
            make.height.equalTo(self).offset(-5);
        }];
    }
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(WIDTH);
        make.height.equalTo(@5);
    }];
    
    [self layoutIfNeeded];
    
}

- (void)setClickRecomment:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag;
    if (self.clickRecommentBlock) {
        self.clickRecommentBlock(index);
    }
}

@end

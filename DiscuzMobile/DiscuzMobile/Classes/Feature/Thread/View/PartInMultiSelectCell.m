//
//  PartInMultiSelectCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/11.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PartInMultiSelectCell.h"
#import "SelectTypeButton.h"

@interface PartInMultiSelectCell()

@property (nonatomic, strong) UIView *selectView;

@end

@implementation PartInMultiSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [FontSize HomecellTimeFontSize14];
    self.titleLab.numberOfLines = 0;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.textColor = MESSAGE_COLOR;
    [self.contentView addSubview:self.titleLab];
    
    self.selectView = [[UIView alloc] init];
    self.selectView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.selectView];
}

- (void)setMultiSelectArray:(NSMutableArray *)multiSelectArray {
    
    _multiSelectArray = multiSelectArray;
    
    if ([DataCheck isValidArray:multiSelectArray]) {
        
        CGFloat x_space = 15;
        CGFloat y_space = 10;
        CGFloat addWidth = 30;
        CGFloat btn_h = 30;
        if (WIDTH == 320) {
            x_space = 10;
            addWidth = 25;
        }
        
        self.titleLab.frame = CGRectMake(15, 10, 80, CGRectGetHeight(self.frame));
        CGFloat selectHeight = 0;
        
        if (multiSelectArray.count > 0) {
            selectHeight = btn_h + y_space * 2;
            
            for (UIView *button in self.selectView.subviews) {
                [button removeFromSuperview];
            }
            
            self.selectView.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 5, 0, WIDTH - CGRectGetWidth(self.titleLab.frame) - 25, selectHeight);
            
            CGFloat allWidth = WIDTH - CGRectGetWidth(self.titleLab.frame) - 25;
            
            __block CGFloat maxX = 0;
            __block NSInteger index = 0;
            __block NSInteger row = 0;
            __block NSInteger roi_row = 0;
            
            [multiSelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                {
                    SelectTypeButton *button = [SelectTypeButton buttonWithType:UIButtonTypeCustom];
                    [button setTitle:obj forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    button.titleLabel.font = [FontSize forumtimeFontSize14];
                    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    CGSize textSize = [obj sizeWithFont:[FontSize forumtimeFontSize14] maxSize:CGSizeMake(allWidth / 2, MAXFLOAT)];
                    CGFloat b_width = textSize.width + addWidth;
                    
                    // ************
                    
                    if (maxX + b_width + x_space >= CGRectGetWidth(self.selectView.frame)) {
                        maxX = 0;
                        if (roi_row == row) {
                            row ++;
                        }
                    }
                    
                    roi_row = row;
                    
                    button.frame = CGRectMake(maxX + x_space, y_space + (btn_h + y_space) * row, b_width, btn_h);
                    maxX = CGRectGetMaxX(button.frame);
                    // ************
                    
                    button.layer.cornerRadius  = 4.0;
                    button.layer.borderWidth = 1.0;
                    button.tag = 10001;
                    button.layer.borderColor = MAIN_COLLOR.CGColor;
                    
                    button.tag = 100 + index;
                    button.isSelect = NO;
                    button.activityValue= obj;
                    
                    [button addTarget:self action:@selector(postxuangxiangClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.selectView addSubview:button];
                    
                    index ++;
                }
            }];
            
            for (int i = 0; i < row; i ++) {
                selectHeight += (btn_h + y_space);
            }
        }
        
        self.titleLab.frame = CGRectMake(15, 10, 80, selectHeight - 10);
        self.selectView.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 5, 0, WIDTH - CGRectGetWidth(self.titleLab.frame) - 25, selectHeight);
    }
    
}

- (CGFloat)cellHeight {
    return CGRectGetMaxY(self.selectView.frame);
}


-(void)postxuangxiangClick:(SelectTypeButton *)btn {
    
    if (btn.isSelect) {
        if ([self.userArray containsObject:btn.activityValue]) {
            
            [self.userArray removeObject:btn.activityValue];
        }
        btn.isSelect = NO;
    } else {
        if (![self.userArray containsObject:btn.activityValue]) {
            
            [self.userArray addObject:btn.activityValue];
        }
        btn.isSelect = YES;
    }
    
    if (self.senduserBlock) {
        self.senduserBlock(self.userArray);
    }
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CenterToolView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "CenterToolView.h"
#import "VerticalImageTextView.h"
#import "TextIconModel.h"

@implementation CenterToolView // 高85

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommit];
    }
    return self;
}

- (NSMutableArray<TextIconModel *> *)iconTextArr {
    if (!_iconTextArr) {
        _iconTextArr = [NSMutableArray array];
    }
    return _iconTextArr;
}

- (void)initCommit {
    self.backgroundColor = [UIColor whiteColor];
    
//    NSArray *arr = @[@"好友",@"收藏",@"消息",@"主题",@"回复"];
    
    NSArray *arr = @[@"好友",@"收藏",@"消息",@"帖子"];
    
    CGFloat item_width = (WIDTH - 24) / 4;
    for (int i = 0; i < 4; i ++) {
        
        TextIconModel *model = [[TextIconModel alloc] init];
        model.iconName = [NSString stringWithFormat:@"ucbar_%d",i];
        model.text = arr[i];
        [self.iconTextArr addObject:model];
        
        VerticalImageTextView *item = [[VerticalImageTextView alloc] initWithFrame:CGRectMake(12 + i * item_width, 12, item_width, CGRectGetHeight(self.frame))];
        item.tag = i;
        item.textLabel.text = model.text;
        item.iconV.image = [UIImage imageNamed:model.iconName];
        [item addTarget:self action:@selector(itemAction:)];
        [self addSubview:item];
    }
}

- (void)itemAction:(VerticalImageTextView *)sender {
    if (self.toolItemClickBlock) {
        self.toolItemClickBlock(sender, sender.tag, self.iconTextArr[sender.tag].text);
    }
}

@end

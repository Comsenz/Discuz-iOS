//
//  BaseDTCell.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/12.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <DTCoreText/DTCoreText.h>

@protocol DTWebClickDelegate <NSObject>
@optional
- (void)linkDidClick:(NSString *)linkUrl;
- (void)webImageClick:(NSString *)imageUrl index:(NSInteger)index;
@end

@interface BaseDTCell : DTAttributedTextCell

@property (nonatomic, strong) NSMutableArray *webImageArray;
@property (nonatomic, strong) NSMutableSet *mediaPlayers;
@property (nonatomic, weak) id<DTWebClickDelegate> webClickDelegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setHTMLString:(NSString *)html options:(NSDictionary*) options;

@end

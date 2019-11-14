//
//  TPNavItemButton.m
//  PandaReader
//
//  Created by WebersonGao on 2019/4/4.
//  Copyright © 2019 ZHWenXue. All rights reserved.
//

#import "TPNavItemButton.h"

@implementation TPNavItemButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect imageFrame = self.imageView.frame;
    if (self.isLeft) {
        imageFrame.origin.x = 0;
    }else {
        imageFrame.origin.x = self.frame.size.width-imageFrame.size.width;
    }
    
    if (self.isBack) {
        imageFrame.origin.x = 5;
    }

    self.imageView.frame = imageFrame;
}

@end

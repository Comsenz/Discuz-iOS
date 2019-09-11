//
//  WSImageModel.h
//  doucui
//
//  Created by Piter on 16/10/12.
//  Copyright © 2016年 lootai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WSImageModel : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, strong) NSString *aid;

@end

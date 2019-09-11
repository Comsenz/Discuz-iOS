//
//  GoodsImageBroseVC.h
//  doucui
//
//  Created by Piter on 16/10/12.
//  Copyright © 2016年 lootai. All rights reserved.
//

#import "WSImageBroswerVC.h"

@interface WSPhotosBroseVC : WSImageBroswerVC
@property (nonatomic, copy) void(^completion)(NSArray <UIImage *> *array);
@property (nonatomic, copy) void(^deleteBlock)(NSInteger sort);
@end

//
//  addressModel.h
//  省市区model
//
//  Created by 耿远风 on 17/7/13.
//  Copyright © 2017年 耿远风. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addressModel : NSObject

/** 地区的ID */
@property (nonatomic,strong)NSString *area_id;

/** 地区的pid */
@property (nonatomic,strong)NSString *area_pid;

/** 地区的名字 */
@property (nonatomic,strong)NSString *area_district;

/** area_level */
@property (nonatomic,strong)NSString *area_level;

/** 地区的子地区 */
@property (nonatomic,strong)NSMutableArray *son;

@end

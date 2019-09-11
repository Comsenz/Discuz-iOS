//
//  DropDownView.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/27.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "DropDownView.h"

@interface DropDownView (){
    NSMutableArray *_imagesArr;
    NSMutableArray *_titleArr;
    NSMutableArray * allowpost;
    NSString       * _allowspecialonly ;
}

@end

@implementation DropDownView

//allowpostspecial=1 是 可以发特殊帖子   1 是投票       9 是所有  活动是 8
-(id)initWithFrame:(CGRect)frame postType:(NSString*)type allowPostSpecial:(id)allowpostspecial  allowsPecialOnly:(NSString *)allowspecialonly {
    
    if ([DataCheck isValidArray:allowpostspecial]) {
        allowpost = allowpostspecial;
    }
    _allowspecialonly = allowspecialonly;
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if ([type isEqualToString:@"postMenu"]) {
            
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thread_postMenuBack"]];
            
            if ([DataCheck isValidString:allowpostspecial]) {
                
                if([allowpostspecial isEqualToString:@"8"]) {
                    _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_ activity", nil];
                    _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"活动帖", nil];
                    
                } else if([allowpostspecial isEqualToString:@"1"]) {
                    _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote", nil];
                    _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖", nil];
                    
                } else if ([allowpostspecial isEqualToString:@"9"]) {
                    _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ activity", nil];
                    _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖",@"活动帖", nil];
                } else {
                    _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ activity", nil];
                    _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖",@"活动帖", nil];
                }
                
                [self initDzUI];
            } else {
                
                _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary", nil];
                _titleArr = [NSMutableArray arrayWithObjects:@"普通帖", nil];
                [self initDzUI];
            }
    
            
        } else if ([type isEqualToString:@"forumMenu"]) {
            
             self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thread_postMenuBack"]];
             _titleArr = [NSMutableArray arrayWithObjects:@"热门板块",@"全部板块",nil];
            [self initForumMenuView];
            
        } else if([type isEqualToString:@"postMenuF"]) {
            
             self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thread_postMenuBack"]];
            _imagesArr = [NSMutableArray array];
            _titleArr = [NSMutableArray array];
            
            if ([DataCheck isValidString:_allowspecialonly]) {
                if ([_allowspecialonly isEqualToString:@"0"]) {
                    [_imagesArr addObject:@"thread_ordinary"] ; // 普通帖
                    [_titleArr addObject:@"普通帖"] ;
                    NSMutableArray * arra = [NSMutableArray arrayWithArray:allowpost];
                    [arra insertObject:@"0" atIndex:0];
                    allowpost = arra;
                }
            }
            
            if ([DataCheck isValidArray:allowpostspecial]) {
                
                for (NSString * str in allowpostspecial) {
                    
                    int a = [str intValue];
                    switch (a) {
                        case 1:
                            [_imagesArr addObject:@"thread_vote"]; // 投票帖
                            [_titleArr addObject:@"投票帖"];
                            break;
                        case 2:
//                            [_imagesArr addObject:@""]; // 商品帖
//                            [_titleArr addObject:@"商品帖"];
                            [allowpost removeObject:@"2"];
                            break;
                        case 3:
//                            [_imagesArr addObject:@""]; // 悬赏帖
//                            [_titleArr addObject:@"悬赏帖"];
                            [allowpost removeObject:@"3"];
                            break;
                        case 4:
                            [_imagesArr addObject:@"thread_ activity"]; // 活动帖
                            [_titleArr addObject:@"活动帖"];
                            break;
                        case 5:
//                            [_imagesArr addObject:@""]; // 辩论帖
//                            [_titleArr addObject:@"辩论帖"];
                            [allowpost removeObject:@"3"];
                            break;
                        default:
                            break;
                    }
                }
                
            }
            
            [self initUI];
        } else if ([type isEqualToString:@"Dropdownbtn"]) {
            
            //  朋友聚会 出外郊游  自驾出行 公益活动 线上活动 自定义
            _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ordinary",@"thread_ordinary",@"thread_ordinary",@"thread_ordinary", nil];
            _titleArr = [NSMutableArray arrayWithObjects:@"朋友聚会",@"出外郊游",@"自驾出行",@"公益活动",@"线上活动",@"自定义", nil];
            [self initDropdownUI];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame activityType:(NSMutableArray *)arr {
    
    if (self = [super initWithFrame:frame]) {
        //  朋友聚会 出外郊游  自驾出行 公益活动 线上活动 自定义
        _titleArr = [NSMutableArray arrayWithArray:arr];
        [self initDropdownUI];
    }
    
    return self;
    
}

#pragma mark - 活动类型
-(void)initDropdownUI {
    
    for (int i =0 ; i <_titleArr.count; i++) {
        
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 28 * i+3 , self.frame.size.width, 28)];
        [self addSubview:view];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];

        button.tag = 1000+i;
        UIImage * img = [UIImage imageNamed:@""];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, img.size.width, 20)];
        imageView.image = img;
        imageView.center = CGPointMake(imageView.center.x, 15);
        [view addSubview:imageView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, 6, 50, 20)];
        label.text = [_titleArr objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:label];
        
        CGRect frameT = self.frame;
        self.frame=CGRectMake(frameT.origin.x, frameT.origin.y+60-1, 96, 6.5+0.25+28 * _titleArr.count);
    }

}

#pragma mark - 掌上论坛原版发帖的下拉列表：普通帖、投票帖等
- (void)initDzUI {
    
    for (int i =0 ; i <_imagesArr.count; i++) {
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * i + 8, self.frame.size.width, 39)];
        [self addSubview:view];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIImage * img = [UIImage imageNamed:[_imagesArr objectAtIndex:i]];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, img.size.width, img.size.height)];
        imageView.image = img;
        imageView.center = CGPointMake(imageView.center.x, 15);
        [view addSubview:imageView];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, 6, 50, 20)];
        label.text = [_titleArr objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:label];
        button.titleLabel.text = [_titleArr objectAtIndex:i];
        
        
        CGRect frameT = self.frame;
        self.frame=CGRectMake(frameT.origin.x, frameT.origin.y, 96, 6.5+0.25+38.25 * _titleArr.count);
        if (iPhone320) {
            CGRect frameT =self.frame;
            self.frame = CGRectMake(frameT.origin.x+5, frameT.origin.y, frameT.size.width, frameT.size.height);
        }
        
    }
    
}


#pragma mark - 红网论坛发帖的下拉列表
- (void)initUI {
    
    for (int i =0 ; i <_imagesArr.count; i++) {
        
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * i + 8, self.frame.size.width, 39)];
 //       view.backgroundColor = i ==1 ?  [UIColor blueColor]:[UIColor yellowColor];
        [self addSubview:view];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + [[allowpost objectAtIndex:i]intValue];
        [view addSubview:button];
        
        UIImage * img = [UIImage imageNamed:[_imagesArr objectAtIndex:i]];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, img.size.width, img.size.height)];
        imageView.image = img;
        imageView.center = CGPointMake(imageView.center.x, 15);
        [view addSubview:imageView];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, 6, 50, 20)];
        label.text = [_titleArr objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:label];
        button.titleLabel.text = [_titleArr objectAtIndex:i];
        
        
            CGRect frameT = self.frame;
          self.frame=CGRectMake(frameT.origin.x, frameT.origin.y, 96, 6.5+0.25+38.25 * _titleArr.count);

        if (iPhone320) {
            CGRect frameT =self.frame;
            self.frame = CGRectMake(frameT.origin.x+5, frameT.origin.y, frameT.size.width, frameT.size.height);
        }
    }
    
}

-(void)buttonClick:(UIButton *)btn{
    
    if ([_delegate respondsToSelector:@selector(postBtnClick:)]) {
         [_delegate postBtnClick:btn];
    }
}

#pragma mark - 热门板块,全部板块
-(void)initForumMenuView{
    
    for (int i =0 ; i < 2; i++) {
        
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * i + 8, self.frame.size.width, 39)];
        [self addSubview:view];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [view addSubview:button];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,9, view.frame.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [_titleArr objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:label];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

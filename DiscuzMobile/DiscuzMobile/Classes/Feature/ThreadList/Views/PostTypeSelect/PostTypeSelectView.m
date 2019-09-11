//
//  PostTypeSelectView.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostTypeSelectView.h"
#import "PostTypeCell.h"

@interface PostTypeSelectView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) NSMutableArray<PostTypeModel *> *allTypeArray;

@end

@implementation PostTypeSelectView

- (NSMutableArray *)allTypeArray {// 控制所有该显示的类型
    if (!_allTypeArray) {
        _allTypeArray = [NSMutableArray array];
        PostTypeModel *common = [PostTypeModel initWithTitle:@"普通帖" imageName:@"thread_ordinary" type:post_normal];
        PostTypeModel *vote = [PostTypeModel initWithTitle:@"投票帖" imageName:@"thread_vote" type:post_vote];
        PostTypeModel *activity = [PostTypeModel initWithTitle:@"活动帖" imageName:@"thread_ activity" type:post_activity];
        PostTypeModel *debate = [PostTypeModel initWithTitle:@"辩论帖" imageName:@"thread_debate" type:post_debate];
        [_allTypeArray addObject:common];
        [_allTypeArray addObject:vote];
        [_allTypeArray addObject:activity];
//        [_allTypeArray addObject:debate];
        
    }
    return _allTypeArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"请选择发帖类型";
    self.titleLab.font = [FontSize NavTitleFontSize18];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = MAIN_TITLE_COLOR;
    [self.contentView addSubview:self.titleLab];
    
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 10, 10) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    self.selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.selectTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"PostTypeCell";
    PostTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[PostTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (self.typeArray.count > 0) {
        PostTypeModel *type = self.typeArray[indexPath.row];
        cell.titleLab.text = type.title;
        cell.iconV.image = [UIImage imageTintColorWithName:type.imageName andImageSuperView:cell.iconV];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.typeArray.count > 0) {
        PostTypeModel *type = self.typeArray[indexPath.row];
        if (self.typeBlock) {
            self.typeBlock(type.type);
        }
    }
}

// 请求网络后获取数据传入。
- (void)setPostType:(NSString *)poll activity:(NSString *)activity debate:(NSString *)debate allowspecialonly:(NSString *)allowspecialonly allowpost:(NSString *)allowpost {
    
    // 这里特殊帖子只包括
    NSDictionary *postDic = @{@"投票帖":poll,
                              @"活动帖":activity,
                              @"辩论帖":debate};
    NSMutableArray *typeArray = [NSMutableArray array];
    if ([allowpost isEqualToString:@"1"]) {
        for (PostTypeModel *typeModel in self.allTypeArray) {
            if ([typeModel.title isEqualToString:@"普通帖"]) {
                if (![allowspecialonly isEqualToString:@"1"]) {
                    [typeArray addObject:typeModel];
                }
            } else {
                if ([[postDic objectForKey:typeModel.title] isEqualToString:@"1"]) {
                    [typeArray addObject:typeModel];
                }
            }
        }
    }
    self.typeArray = typeArray;
}

// 设置完typeArray要更新UI
- (void)setTypeArray:(NSMutableArray *)typeArray {
    
    _typeArray = typeArray;
    
    CGFloat allHeight = 80 * typeArray.count + 65 + 20;
    CGFloat close_width = 16.0;
    
    self.contentView.frame = CGRectMake(30, HEIGHT - allHeight - 100, WIDTH - 60, allHeight);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 8;
    
    self.titleLab.frame = CGRectMake(10, 15, CGRectGetWidth(self.contentView.frame) - close_width - 20, 30);
    self.closeBtn.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - close_width - 16, 16, close_width, close_width);
    self.selectTableView.frame = CGRectMake(30, CGRectGetMaxY(self.titleLab.frame) + 10, CGRectGetWidth(self.contentView.frame) - 60, 80 * typeArray.count);
    
    [self.selectTableView reloadData];
    
}

//- (void)setAllowpost:(NSString *)allowpostspecial {
//    
//    NSMutableArray *imagesArr = [NSMutableArray array];
//    NSMutableArray *titleArr = [NSMutableArray array];
//    
//    if ([DataCheck isValidString:allowpostspecial]) {
//        
//        if([allowpostspecial isEqualToString:@"8"]) {
//            imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_ activity", nil];
//            titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"活动帖", nil];
//            
//        } else if([allowpostspecial isEqualToString:@"1"]) {
//            
//            imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote", nil];
//            titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖", nil];
//            
//        } else if ([allowpostspecial isEqualToString:@"9"]) {
//            imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ activity", nil];
//            titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖",@"活动帖", nil];
//        } else {
//            imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ activity", nil];
//            titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖",@"活动帖", nil];
//        }
//        
//    } else {
//        
//        imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary", nil];
//        titleArr = [NSMutableArray arrayWithObjects:@"普通帖", nil];
//    }
//    
//    NSMutableArray *typeArray = [NSMutableArray array];
//    for (NSInteger i = 0; i < imagesArr.count; i ++) {
//        PostTypeModel *model = [[PostTypeModel alloc] init];
//        model.title = titleArr[i];
//        if ([model.title isEqualToString:@"普通帖"]) {
//            model.type = post_normal;
//        }
//        else if ([model.title isEqualToString:@"投票帖"]) {
//            model.type = post_vote;
//        }
//        else if ([model.title isEqualToString:@"活动帖"]) {
//            model.type = post_activity;
//        }
//        else if ([model.title isEqualToString:@"辩论帖"]) {
//            model.type = post_debate;
//        }
//        model.imageName = imagesArr[i];
//        [typeArray addObject:model];
//    }
//    self.typeArray = typeArray;
//
//}


/*
- (void)setPostType:(NSString *)poll andActivity:(NSString *)activity andDebate:(NSString *)debate {
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    
    if ([poll isEqualToString:@"1"] && [activity isEqualToString:@"1"] && [debate isEqualToString:@"1"]) {
        imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ activity",@"thread_ activity", nil];
        titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖",@"活动帖", @"辩论帖",nil];
    }
    else if ([poll isEqualToString:@"1"]) {
        imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote", nil];
        titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖", nil];
    }
    else if ([activity isEqualToString:@"1"]) {
        imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_ activity", nil];
        titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"活动帖", nil];
    }
    else if ([debate isEqualToString:@"1"]) {
        imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_ activity", nil];
        titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"辩论帖", nil];
    }
    else {
        imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary", nil];
        titleArr = [NSMutableArray arrayWithObjects:@"普通帖", nil];
    }
    
    NSMutableArray *typeArray = [NSMutableArray array];
    for (NSInteger i = 0; i < imagesArr.count; i ++) {
        PostTypeModel *model = [[PostTypeModel alloc] init];
        model.title = titleArr[i];
        if ([model.title isEqualToString:@"普通帖"]) {
            model.type = post_normal;
        }
        else if ([model.title isEqualToString:@"投票帖"]) {
            model.type = post_vote;
        }
        else if ([model.title isEqualToString:@"活动帖"]) {
            model.type = post_activity;
        }
        else if ([model.title isEqualToString:@"辩论帖"]) {
            model.type = post_debate;
        }
        model.imageName = imagesArr[i];
        [typeArray addObject:model];
    }
    self.typeArray = typeArray;
    
}
*/

//{
//
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thread_postMenuBack"]];
//    
//    if ([DataCheck isValidString:allowpostspecial]) {
//        
//        if([allowpostspecial isEqualToString:@"8"]) {
//            _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_ activity", nil];
//            _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"活动帖", nil];
//            
//        } else if([allowpostspecial isEqualToString:@"1"]) {
//            _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote", nil];
//            _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖", nil];
//            
//        } else if ([allowpostspecial isEqualToString:@"9"]) {
//            _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ activity", nil];
//            _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖",@"活动帖", nil];
//        } else {
//            _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary",@"thread_vote",@"thread_ activity", nil];
//            _titleArr = [NSMutableArray arrayWithObjects:@"普通帖",@"投票帖",@"活动帖", nil];
//        }
//        
//        [self initDzUI];
//    } else {
//        
//        _imagesArr = [NSMutableArray arrayWithObjects:@"thread_ordinary", nil];
//        _titleArr = [NSMutableArray arrayWithObjects:@"普通帖", nil];
//        [self initDzUI];
//    }
//    
//    
//}

//- (NSMutableArray *)typeArray {
//    if (!_typeArray) {
//        _typeArray = [NSMutableArray array];
//    }
//    return _typeArray;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

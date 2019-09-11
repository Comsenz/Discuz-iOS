//
//  LiveRootController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveRootController.h"
#import <Pusher/Pusher.h>
#import "UIAlertController+Extension.h"

#import "UploadTool.h"
#import "CollectionTool.h"

#import "JTContainerController.h"
#import "LiveDetailViewController.h"
#import "LiveInteractionViewController.h"
#import "OtherUserController.h"

#import "HMSegmentedControl.h"
#import "LiveDetailModel.h"
#import "HotLivelistModel.h"
#import "LoginController.h"
#import "WSImageModel.h"

#import "EmoticonKeyboard.h"
#import "LiveInfoView.h"


@interface LiveRootController () <UIScrollViewDelegate, PTPusherDelegate>

@property (nonatomic, strong) PTPusher *client;

@property (nonatomic, strong) LiveInfoView *infoView;
@property (nonatomic, strong) JTContainerController *rootVc;
@property (nonatomic, strong) NSMutableArray *controllerArr;

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, strong) EmoticonKeyboard *emoKeyboard;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *badage;

@property (nonatomic, strong) LiveDetailViewController *detail;
@property (nonatomic, strong) LiveInteractionViewController *interaction;

@property (nonatomic, strong) NSMutableArray *detaiArr;
@property (nonatomic, strong) NSMutableArray *interactionArr;

@property (nonatomic, strong) NSMutableDictionary *allowpermDic;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong)  NSMutableDictionary *dateTimeDic;

@end

@implementation LiveRootController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        [self.emoKeyboard hideCustomerKeyBoard];
    }
    [super willMoveToParentViewController:parent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginedRefresh) name:LOGINEDREFRESHGETINFO object:nil];
    
    [self initUI];
    
    [self initPusher];
    
    WEAKSELF;

    self.detail.hideKeyboard = ^{
        [weakSelf.emoKeyboard hideCustomerKeyBoard];
    };
    
    self.interaction.hideKeyboard = ^ {
        [weakSelf.emoKeyboard hideCustomerKeyBoard];
    };
    
    
}


- (void)initPusher {
    
    self.client = [PTPusher pusherWithKey:@"30dc23e721dbeb25fa3b" delegate:self encrypted:YES];
    
    // subscribe to channel and bind to event
    PTPusherChannel *channel = [self.client subscribeToChannelNamed:@"livethread"];
    
    WEAKSELF;
    [channel bindToEventNamed:@"thread" handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictianary of the JSON object received
        [weakSelf getPushAfter:channelEvent];
    }];
    
    [self.client connect];
}

- (void)getPushAfter:(PTPusherEvent *)channelEvent {
    // channelEvent.data is a NSDictianary of the JSON object received
    
    NSString *message = [channelEvent.data objectForKey:@"message"];
    DLog(@"message received: %@", message);
    NSError * error = nil;
    NSData * getJsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
    DLog(@"%@",getDict);
    if (self.listModel.tid == nil) {
        return;
    }
    
    DLog(@"%@ ==== %@",self.listModel.tid,[getDict objectForKey:@"tid"]);
    if ([self.listModel.tid isEqualToString:[getDict objectForKey:@"tid"]] && ![[Environment sharedEnvironment].member_uid isEqualToString:self.listModel.authorid]) {
        self.badage.hidden = NO;
        LiveDetailModel *liveModel = [[LiveDetailModel alloc] init];
        [liveModel setValuesForKeysWithDictionary:getDict];
        
        
        
        if ([liveModel.authorid isEqualToString:self.listModel.authorid]) {
            [self.detail.detaiArr insertObject:liveModel atIndex:0];
            NSString *keyTime = [NSDate timeStringFromTimestamp:liveModel.dbdateline format:@"yyyy年MM月dd日"];
            [self.HUD showLoadingMessag:@"刷新中" toView:self.view];
            
            if ([DataCheck isValidArray:[self.detail.dateTimeDic objectForKey:keyTime]]) {
                NSMutableArray *arr = [self.detail.dateTimeDic objectForKey:keyTime];
                
                LiveDetailModel *firstModel = arr[0];
                
                if (![firstModel.pid isEqualToString:liveModel.pid]) {
                    [arr insertObject:liveModel atIndex:0];
                }
                
                [self.detail sortLiveDetail];
                
            } else {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:liveModel];
                [self.detail.dateTimeDic setValue:arr forKey:keyTime];
                
                [self.detail sortLiveDetail];
            }
            
            self.detail.oldArray = [NSMutableArray arrayWithArray:self.detail.detaiArr];
            
        } else {
            if ([DataCheck isValidArray:self.interaction.dataSourceArr]) {
                LiveDetailModel *firstModel = self.interaction.dataSourceArr[0];
                if (![firstModel.pid isEqualToString:liveModel.pid]) {
                    [self.interaction.dataSourceArr insertObject:liveModel atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.interaction.cellHeights removeAllObjects];
                    [self.interaction.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                }
            } else {
                [self.interaction.dataSourceArr insertObject:liveModel atIndex:0];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.interaction.cellHeights removeAllObjects];
                [self.interaction.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            }
            
            
        }
        
        [self.detail emptyShow];
        [self.interaction emptyShow];
        
    }
    
}


- (void)initUI {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat infoHeight = 85 + 15 + 5;
    self.infoView = [[LiveInfoView alloc] initWithFrame:CGRectMake(0, self.navbarMaxY, WIDTH, infoHeight)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.infoView];
    
    
    [self.infoView setInfo:_listModel];
    [self.infoView.collectionBtn addTarget:self action:@selector(collectionLive:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoAction)];
    [self.infoView.headIcon addGestureRecognizer:tap];
    
    NSArray *arrM = @[@"直播",@"互动"];
    // 添加导航
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:arrM];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.frame = CGRectMake(0, infoHeight + self.navbarMaxY, WIDTH , 44);
    self.segmentedControl.borderType = HMSegmentedControlBorderTypeBottom | HMSegmentedControlBorderTypeTop;
    self.segmentedControl.borderColor = LINE_COLOR;
    self.segmentedControl.borderWidth = 0.5;
    [self.segmentedControl setBackgroundColor:[UIColor whiteColor]];
    CGFloat minsize = 16.0;
    CGFloat maxsize = 17.0;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthMorelittle;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.segmentedControl setSelectionIndicatorColor:MAIN_COLLOR];
    [self.segmentedControl setSelectionIndicatorHeight:2.0];
    
    [self.segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] init];
        attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : LIGHT_TEXT_COLOR,NSFontAttributeName:[FontSize SlideTitleFontSize:minsize andIsBold:NO]}];
        if (selected) {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : MAIN_COLLOR,NSFontAttributeName:[FontSize SlideTitleFontSize:maxsize andIsBold:YES]}];
        }
        return attString;
    }];
    
    _badage = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 0.8, 10, 10, 10)];
    _badage.backgroundColor = [UIColor redColor];
    _badage.layer.masksToBounds = YES;
    _badage.layer.cornerRadius = 5;
    [self.segmentedControl addSubview:_badage];
    
    WEAKSELF;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf setSelectedAtIndex:index];
    }];
    
    [[self segmentedControl] setSelectedSegmentIndex:0];
    [self.view addSubview:self.segmentedControl];
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame) + 5, WIDTH, HEIGHT - CGRectGetMaxY(self.segmentedControl.frame) - 44)];
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
    [self.view addSubview:self.scrollview];
    
    self.detail = [[LiveDetailViewController alloc] init];
    self.detail.listModel = self.listModel;
    self.detail.title = @"直播";
    self.detail.sendParameterBlock = ^(id responseObject) {
        weakSelf.allowpermDic = [[responseObject objectForKey:@"Variables"] objectForKey:@"allowperm"];
        
        NSArray *newList = [[responseObject objectForKey:@"Variables"] objectForKey:@"postlist"];
        
        NSInteger *sort = 0;
        for (NSDictionary *listItem in newList) {
            
            if (sort == 0) {
                weakSelf.listModel.pid = [listItem objectForKey:@"pid"];
            }
            sort ++;
        }
        [weakSelf judgeCollection:responseObject];
    };
    
    self.interaction = [[LiveInteractionViewController alloc] init];
    self.interaction.listModel = self.listModel;
    self.interaction.title = @"互动";
    
    [self.controllerArr addObject:self.detail];
    [self.controllerArr addObject:self.interaction];
    
    
    self.scrollview.contentSize = CGSizeMake(WIDTH * 2, HEIGHT - CGRectGetMaxY(self.segmentedControl.frame) - 50);
    
    self.detail.view.frame = CGRectMake(0, 0, WIDTH, self.scrollview.frame.size.height);
    [self addChildViewController:self.detail];
    [self.scrollview addSubview:self.detail.view];
    
//    self.interaction.view.frame = CGRectMake(WIDTH, 0, WIDTH, self.scrollview.frame.size.height);
//    [self addChildViewController:self.interaction];
//    [self.scrollview addSubview:self.interaction.view];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    
    [self createHPGrowingTextView];
}

- (void)judgeCollection:(id)responseObject {
    // 是否收藏了
    if ([DataCheck isValidString:[[[responseObject objectForKey:@"Variables"] objectForKey:@"thread"] objectForKey:@"favorited"]]) {
        if ([[[[responseObject objectForKey:@"Variables"] objectForKey:@"thread"] objectForKey:@"favorited"] isEqualToString:@"1"]) { // 已收藏
            [self setIsCollection:self.infoView.collectionBtn];
        } else {
            [self setNotCollection:self.infoView.collectionBtn];
        }
    }
}



#pragma mark - 跳转个人中心
- (void)userInfoAction {
    if ([DataCheck isValidString:self.listModel.authorid]) {
        
        if (![self isLogin]) {
            return;
        }
        [self.emoKeyboard hideCustomerKeyBoard];
        OtherUserController * ovc = [[OtherUserController alloc] init];
        ovc.authorid = self.listModel.authorid;
        [self showViewController:ovc sender:nil];
    }
}

// MARK - 登录后刷新一下
- (void)loginedRefresh {
    [self.detail refreshData];
}

#pragma mark - 收藏
- (void)collectionLive:(UIButton *)btn {
    
    if (![self isLogin]) {
        return;
    }
    
    NSDictionary * getdic=@{@"id":self.listModel.tid};
    NSDictionary * dic=@{@"formhash":[Environment sharedEnvironment].formhash};
    if (btn.tag == 100001) {
        [[CollectionTool shareInstance] collectionThread:getdic andPostdic:dic success:^{
            [self setIsCollection:btn];
        } failure:nil];
        
    } else if (btn.tag==100002) {
        
        NSDictionary *getDic = @{@"id":self.listModel.tid,
                                 @"type":@"thread"
                                 };
        NSDictionary *postDic = @{@"deletesubmit":@"true",
                                  @"formhash":[Environment sharedEnvironment].formhash
                                  };
        [[CollectionTool shareInstance] deleCollection:getDic andPostdic:postDic success:^{
            [self setNotCollection:btn];
        } failure:nil];
        
    }
    
}

- (void)setIsCollection:(UIButton *)btn {
    [btn setImage:[UIImage imageNamed:@"collection_ok"] forState:UIControlStateNormal];
    btn.tag=100002;
}

- (void)setNotCollection:(UIButton *)btn {
    [btn setImage:[[UIImage imageNamed:@"collection"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageTintColorWithName:@"collection" andImageSuperView:btn] forState:UIControlStateNormal];
    btn.tag = 100001;
}


#pragma mark -  创建表情键盘
- (void)createHPGrowingTextView{
    
    [self.view addSubview:self.emoKeyboard];
    self.emoKeyboard.backgroundColor = MAIN_GRAY_COLOR;
    self.emoKeyboard.textBarView.style = attachment_textBar;
    
    if ([self.listModel.authorid isEqualToString:[Environment sharedEnvironment].member_uid]) {
        _emoKeyboard.textBarView.textView.placeholderText = @"发布直播";
    } else {
        _emoKeyboard.textBarView.textView.placeholderText = @"你的评论将进入互动";
    }
    
    [_emoKeyboard.textBarView.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    WEAKSELF;
    _emoKeyboard.uploadView.pickerView.navigationController = self.navigationController;
    _emoKeyboard.uploadView.pickerView.HUD = self.HUD;
    _emoKeyboard.uploadView.pickerView.finishPickingBlock = ^(NSArray *WSImageModels) {
        [weakSelf uploadImageArr:WSImageModels];
    };
    
    self.emoKeyboard.sendBlock = ^ {
        [weakSelf sendAction];
    };
    self.emoKeyboard.textBarView.sendMessageBlock = ^ {
        [weakSelf.emoKeyboard hideCustomerKeyBoard];
        [weakSelf sendAction];
    };
}

- (void)uploadImageArr:(NSArray *)imageArr {
    
    NSString *uploadhash = @"";
    if ([DataCheck isValidDictionary:self.allowpermDic]) {
        uploadhash = [self.allowpermDic objectForKey:@"uploadhash"];
    }
    
    if (![DataCheck isValidString:uploadhash]) {
        [MBProgressHUD showInfo:@"无权限上传图片"];
        return;
    }
    NSMutableDictionary *dic=@{@"hash":uploadhash,
                        @"uid":[NSString stringWithFormat:@"%@",[Environment sharedEnvironment].member_uid],
                        }.mutableCopy;
    NSMutableDictionary * getdic=@{@"fid":self.listModel.fid}.mutableCopy;
    
    [self.emoKeyboard.uploadView uploadImageArray:imageArr.copy getDic:getdic postDic:dic];
    
}

- (void)sendAction {
    [self postReplay];
}

#pragma mark - 回复帖子
-(void)postReplay{
    
    if (![self isLogin]) {
        return;
    }
    
    //begain回复
    if ([self.emoKeyboard.textBarView.textView.text length] == 0) {
        [UIAlertController alertTitle:@"请不要回复空帖" message:nil controller:self doneText:@"OK" cancelText:nil doneHandle:nil cancelHandle:nil];
        [self.emoKeyboard.textBarView.textView resignFirstResponder];
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.emoKeyboard.textBarView.textView.text forKey:@"message"];
    [dic setObject:[Environment sharedEnvironment].formhash forKey:@"formhash"];
    [dic setObject:@"IOS" forKey:@"mobiletype"];
    [dic setObject:self.listModel.tid forKey:@"tid"];
    
    NSArray *aidArr = self.emoKeyboard.uploadView.uploadModel.aidArray;
    if (aidArr.count > 0) {
        for (int i=0; i < aidArr.count; i++){
            DLog(@"ar 2");
            NSString *description = @"";
            [dic setObject:description forKey:[NSString stringWithFormat:@"attachnew[%@][description]",[aidArr objectAtIndex:i]]];
        }
    }
    
    [self sendReply:dic];
    
}

- (void)sendReply:(NSDictionary *)dic {
    
//    id responseObject;
//    [self rightNow:dic andResponse:responseObject];
//    [self.emoKeyboard clearData];
//    return;
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"发帖中..." toView:self.view];
        request.methodType = JTMethodTypePOST;
        request.urlString = url_Sendreply;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        
        NSString *messageval = [responseObject messageval];
        if ([messageval containsString:@"succeed"] || [messageval containsString:@"success"]) {
            self.emoKeyboard.textBarView.textView.text = nil;
            [MBProgressHUD showInfo:@"发送成功"];
            
            NSDictionary *getDic = @{@"formhash":[Environment sharedEnvironment].formhash};
            NSMutableDictionary *postDic = @{@"message":[dic objectForKey:@"message"],
                                             @"tid":self.listModel.tid,
                                             @"authorid":[[Environment sharedEnvironment] member_uid],
                                             @"author":[[Environment sharedEnvironment] member_username],
                                             @"pid":[[responseObject objectForKey:@"Variables"] objectForKey:@"pid"]}.mutableCopy;
            NSArray *aidArr = self.emoKeyboard.uploadView.uploadModel.aidArray;
            if (self.emoKeyboard.uploadView.uploadModel.aidArray.count > 0) {
                [postDic setValue:aidArr forKey:@"image"];
            }
            
            [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
                request.methodType = JTMethodTypePOST;
                //                    request.urlString = url_LivePusher;
                request.getParam = getDic;
                request.parameters = postDic;
                
            } success:^(id responseObject, JTLoadType type) {
                
                
            } failed:^(NSError *error) {
                
                
            }];
            
            [self rightNow:dic andResponse:responseObject];
            
            [self.emoKeyboard clearData];
        }
        else {
            [MBProgressHUD showInfo:[responseObject messagestr]];
        }
        
        
    } failed:^(NSError *error) {
        [self.HUD hideAnimated:YES];
        [self serverError:error];
    }];
    
}

// 发完后立刻更新
- (void)rightNow:(NSDictionary *)dic andResponse:(id)responseObject {
    LiveDetailModel *live = [[LiveDetailModel alloc] init];
    live.message = [dic objectForKey:@"message"];
    live.avatar = [Environment sharedEnvironment].member_avatar;
    live.author = [Environment sharedEnvironment].member_username;
    live.imglist = [self.emoKeyboard.uploadView.pickerView getPhotos].copy;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    live.dbdateline = [NSString stringWithFormat:@"%f",now];
    
    NSString *todayStr = [[NSDate date] stringFromDateFormat:@"yyyy-MM-dd HH:mm"];
    live.dateline = todayStr;
    if (responseObject != nil) {
        live.pid = [[responseObject objectForKey:@"Variables"] objectForKey:@"pid"];
    }
    
    
    if ([[Environment sharedEnvironment].member_uid isEqualToString:_listModel.authorid]) {
        [self.detail.detaiArr insertObject:live atIndex:0];
        NSString *keyTime = [NSDate timeStringFromTimestamp:live.dbdateline format:@"yyyy年MM月dd日"];
        [self.HUD showLoadingMessag:@"刷新中" toView:self.view];
        if ([DataCheck isValidArray:[self.detail.dateTimeDic objectForKey:keyTime]]) {
            NSMutableArray *arr = [self.detail.dateTimeDic objectForKey:keyTime];
            [arr insertObject:live atIndex:0];
            
            [self.detail sortLiveDetail];
            
        } else {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:live];
            [self.detail.dateTimeDic setValue:arr forKey:keyTime];
            
            [self.detail sortLiveDetail];
        }
        
        self.detail.oldArray = [NSMutableArray arrayWithArray:self.detail.detaiArr];
    } else {
        [self.interaction.dataSourceArr insertObject:live atIndex:0];
        [self.interaction.tableView reloadData];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.interaction.cellHeights removeAllObjects];
//        [self.interaction.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)serverError:(NSError *)error {
    DLog(@"%@",error);
    [self showServerError:error];
    [self.HUD hideAnimated:YES];
}

- (EmoticonKeyboard *)emoKeyboard {
    if (_emoKeyboard == nil) {
        CGFloat tabbarH = 50;
        _emoKeyboard = [[EmoticonKeyboard alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - tabbarH - SafeAreaBottomHeight, WIDTH, tabbarH)];

    }
    return _emoKeyboard;
}

#pragma mark - collectionView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
    [self.segmentedControl  setSelectedSegmentIndex:index];
    
    if (index == 1 && self.childViewControllers.count < 2) {
        self.interaction.view.frame = CGRectMake(WIDTH, 0, WIDTH, self.scrollview.frame.size.height);
        [self addChildViewController:self.interaction];
        [self.scrollview addSubview:self.interaction.view];
    }
    if (index == 1) {
        self.badage.hidden = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.emoKeyboard hideCustomerKeyBoard];
}

#pragma mark - setting

- (void)setSelectedAtIndex:(NSInteger)selectedIndex {
    
    CGFloat offsetX = self.view.bounds.size.width * selectedIndex;
    self.scrollview.contentOffset = CGPointMake(offsetX, 0);
}

- (NSMutableDictionary *)dateTimeDic {
    if (!_dateTimeDic) {
        _dateTimeDic = [NSMutableDictionary dictionary];
    }
    return _dateTimeDic;
}

- (NSMutableArray *)detaiArr {
    if (!_detaiArr) {
        _detaiArr = [NSMutableArray array];
    }
    return _detaiArr;
}

- (NSMutableArray *)interactionArr {
    if (!_interactionArr) {
        _interactionArr = [NSMutableArray array];
    }
    return _interactionArr;
}


- (NSMutableArray *)controllerArr {
    if (!_controllerArr) {
        _controllerArr = [NSMutableArray array];
    }
    return _controllerArr;
}


@end

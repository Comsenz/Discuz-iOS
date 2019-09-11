 //
//  ThreadViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/14.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "ThreadViewController.h"
#import "WebViewJavascriptBridge.h"
#import "UIAlertController+Extension.h"
#import "CollectionTool.h"
#import "UploadTool.h"

#import "LoginController.h"
#import "WebViewJavascriptBridge.h"
#import "OtherUserController.h"
#import "ViewPollPotionNumberViewController.h"
#import "ManageActivityController.h"
#import "PartInActitivityController.h"

#import "ThreadDetailView.h"
#import "ThreadModel.h"
#import "ResponseMessage.h"
#import "SeccodeverifyView.h"
#import "PraiseHelper.h"
#import "WSImageModel.h"
#import "JudgeImageModel.h"
#import "DZDevice.h"

#import "ShareCenter.h"
#import "JTWebImageBrowerHelper.h"

@interface ThreadViewController ()<UITextFieldDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ThreadDetailView *detailView; // 详细页view 替换原来的view
@property (nonatomic, unsafe_unretained)CGFloat currentScale;
@property (nonatomic, strong) WebViewJavascriptBridge * javascriptBridge;

@property (nonatomic, assign) BOOL  isReferenceReply;           // 是否是 引用回复
@property (nonatomic, strong) NSString * noticetrimstr;         // 引用回复内容
@property (nonatomic, strong) NSString * reppid;                // 被引用帖子pid
@property (nonatomic, strong) NSString * jubaoPid;              // 举报 id

@property (nonatomic,strong) NSMutableArray *picurlArray; // 页面图片 （接口限制，只有一张）

// 验证码
@property (nonatomic, strong) SeccodeverifyView *verifyView;

@property (nonatomic, strong) NSString *preSalkey;

@property (nonatomic, strong) ThreadModel *threadModel;

@end

@implementation ThreadViewController
@synthesize javascriptBridge = _bridge;

#pragma mark - life cycle
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
        [self.detailView.emoKeyboard hideCustomerKeyBoard];
    }
    [super willMoveToParentViewController:parent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.HUD hide];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSDictionary *dic = @{@"tid":self.tid,@"page":[NSString stringWithFormat:@"%d",self.currentPageId]};
    [DZApiRequest cancelRequest:url_ThreadDetail getParameter:dic completion:^(NSString *urlString) {
        DLog(@"取消请求：%@",urlString);
    }];
}

- (void)loadView {
    [super loadView];
    self.detailView = [[ThreadDetailView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - SafeAreaBottomHeight)];
    self.view = self.detailView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 点击webview的时候收起键盘
- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self.detailView.emoKeyboard hideCustomerKeyBoard];
}

-(void)handlePinches:(UIPinchGestureRecognizer *)paramSender {
    
    if(paramSender.state == UIGestureRecognizerStateEnded) {
        self.currentScale = paramSender.scale;
        self.detailView.webView.scrollView.zoomScale = self.currentScale;
    } else if(paramSender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f) {
        paramSender.scale = self.currentScale;
        self.detailView.webView.scrollView.zoomScale = self.currentScale;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    self.currentPageId =1;
    [self.detailView.webView.scrollView addSubview:self.emptyView];
    [self commitInit];
    [self newDownLoadData];
    [self addNotifi];
}

- (void)commitInit {
    // 设置代理
    self.detailView.webView.delegate = self;
    self.detailView.webView.scrollView.delegate = self;
    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
    [self.detailView.webView addGestureRecognizer:gestureRecognizer];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapges.delegate = self;
    [self.detailView.webView addGestureRecognizer:tapges];
    
    WEAKSELF;
    
    self.detailView.emoKeyboard.textBarView.praiseBlock = ^ {
        [weakSelf createPraise:nil];
    };
    self.detailView.emoKeyboard.uploadView.pickerView.navigationController = self.navigationController;
    self.detailView.emoKeyboard.uploadView.pickerView.HUD = self.HUD;
    self.detailView.emoKeyboard.uploadView.pickerView.finishPickingBlock = ^(NSArray *WSImageModels) {
        [weakSelf uploadImageArr:WSImageModels];
    };
    
    self.detailView.emoKeyboard.textBarView.collectionBlock = ^ (UIButton *sender){
        [weakSelf rightBarClick:sender];
    };
    
    self.detailView.emoKeyboard.textBarView.shareBlock = ^ {
        [weakSelf shareSome];
    };
    
    self.detailView.emoKeyboard.sendBlock = ^ {
        [weakSelf sendAction];
    };
    self.detailView.emoKeyboard.textBarView.sendMessageBlock = ^ {
        [weakSelf sendAction];
    };
    
    //刷新  下载数据
    self.detailView.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPageId = 1;
        [weakSelf newDownLoadData];
    }];
    
    self.detailView.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.detailView.webView.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPageId ++;
        [weakSelf newDownLoadData];
    }];
    ((MJRefreshAutoFooter *)self.detailView.webView.scrollView.mj_footer).triggerAutomaticallyRefreshPercent = -20;
    
    //  创建bridge
    [self createBridge];
}

- (void)uploadImageArr:(NSArray *)imageArr {
    NSString *uploadhash = self.threadModel.uploadhash;
    if (![DataCheck isValidString:uploadhash]) {
        [MBProgressHUD showInfo:@"无权限上传图片"];
        return;
    }
    
    NSDictionary *dic=@{@"hash":uploadhash,
                        @"uid":[Environment sharedEnvironment].member_uid,
                        };
    NSDictionary * getdic=@{@"fid":self.threadModel.fid};
    [self.HUD showLoadingMessag:@"" toView:self.view];
    [self.detailView.emoKeyboard.uploadView uploadImageArray:imageArr.copy getDic:getdic postDic:dic];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 添加通知
- (void)addNotifi {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTappedAction:) name:STATUSBARTAP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWeb) name:REFRESHWEB object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginedReshData) name:LOGINEDREFRESHGETINFO object:nil];
}

- (void)refreshWeb {
    self.currentPageId = 1;
    [self newDownLoadData];
}

#pragma mark - 建立webview桥接
-(void)createBridge {
    
    /*
     * 必写，JS调用OC
     */
    WEAKSELF;
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.detailView.webView];
    [_bridge setWebViewDelegate:self];
    
    /*
     *JS调用OC时必须写的，注册一个JS调用OC的方法
     */
    //注册一个供UI端调用的名为testObjcCallback的处理器，并定义用于响应的处理逻辑
    [_bridge registerHandler:@"onShare" handler:^(id data, WVJBResponseCallback responseCallback) {
      // 分享
        [weakSelf shareSome];
    }];
    
    [_bridge registerHandler:@"onPraise" handler:^(id data, WVJBResponseCallback responseCallback) {
       // 点赞
        [weakSelf createPraise:data];
    }];
    
    [_bridge registerHandler:@"supportDebate" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([DataCheck isValidString:data]) {
            if ([data isEqualToString:@"0"]) {
                NSLog(@"支持正方辩手");
            } else if ([data isEqualToString:@"1"]) {
                NSLog(@"支持反方辩手");
            }
        }
    }];
    
    [_bridge registerHandler:@"joinDebate" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([DataCheck isValidString:data]) {
            if ([data isEqualToString:@"0"]) {
                NSLog(@"加入正方辩手");
            } else if ([data isEqualToString:@"1"]) {
                NSLog(@"加入反方辩手");
            }
        }
    }];
    
    [_bridge registerHandler:@"endDebate" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"结束辩论");
    }];
    
    [_bridge registerHandler:@"onDiscussUser" handler:^(id data, WVJBResponseCallback responseCallback) {
       // 引用回复
        [weakSelf ReferenceReply:data textview:weakSelf.detailView.emoKeyboard.textBarView.textView];
    }];
    
    [_bridge registerHandler:@"onUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
         //查看用户信息
        [weakSelf creatOterUserCenterVC:data];
    }];
    
    [_bridge registerHandler:@"onThreadThumbsClicked" handler:^(id data, WVJBResponseCallback responseCallback) {
        //查看大图
        weakSelf.picurlArray = [NSMutableArray array];
        NSString *urlstr = (NSString *)data;
        [weakSelf.picurlArray addObject:urlstr];
        // 创建图片浏览
        [[JTWebImageBrowerHelper shareInstance] showPhotoImageSources:weakSelf.picurlArray thumImages:weakSelf.picurlArray currentIndex:0 imageContainView:weakSelf.detailView.webView];
    }];
    
    [_bridge registerHandler:@"onthreadContentThumbsClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableArray *imgs = [data objectForKey:@"imgs"];
        NSString *urlstr = [data objectForKey:@"url"];
        NSInteger index = [imgs indexOfObject:urlstr];
        if (index >= imgs.count) {
            index = 0;
        }
        [[JTWebImageBrowerHelper shareInstance] showPhotoImageSources:imgs thumImages:imgs currentIndex:index imageContainView:weakSelf.detailView.webView];
    }];
    
    [_bridge registerHandler:@"onLoadMore" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 加载更多
    }];
   
    [_bridge registerHandler:@"onSendPoll" handler:^(id data, WVJBResponseCallback responseCallback) {
         // 提交投票
        if (data) {
            [weakSelf createPostVote:data];
        }
    }];
    
    [_bridge registerHandler:@"onVisitVoters" handler:^(id data, WVJBResponseCallback responseCallback) {
         //查看参与投票人
        [weakSelf createVisitVotesrs:data];
    }];
    
    [_bridge registerHandler:@"onSubmit" handler:^(id data, WVJBResponseCallback responseCallback) {
        //参加活动取消活动
        [weakSelf createActivitie:weakSelf.threadModel.isActivity];
    }];
    
    [_bridge registerHandler:@"onComplain" handler:^(id data, WVJBResponseCallback responseCallback) {
        //举报
        weakSelf.jubaoPid = data;
        [weakSelf createComplain];
    }];
    
    [_bridge registerHandler:@"manageActive" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf manageActivity];
    }];
}

#pragma mark  - 参加活动&取消活动
- (void)createActivitie:(BOOL)data{
    
//    // applied = 1; ：1 活动为存在 已参加或者 审批   button = cancel;  button = join;  有button Key 说明 能参加或者取消     closed = 0;   过期的时候 为 1   "is_ex" = 0; 过期的时候为 1
    
    if (self.threadModel.isActivity) {
        //参加活动
        PartInActitivityController * partinVc = [[PartInActitivityController alloc]init];
        partinVc.threadModel = self.threadModel;
        [self.navigationController pushViewController:partinVc animated:YES];
        
    } else {
        
        NSString *message = @"确定取消报名？";
        NSString *donetip = @"确定";
        [UIAlertController alertTitle:@"提示" message:message controller:self doneText:donetip cancelText:@"取消" doneHandle:^{
            [self cancelActivity];
        } cancelHandle:nil];
    }
}

- (void)manageActivity {
    ManageActivityController *mgActive = [[ManageActivityController alloc] init];
    mgActive.threadModel = self.threadModel;
    [self showViewController:mgActive sender:nil];
}

- (void)cancelActivity {
    
    //取消活动
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
        NSDictionary * dic = @{@"tid":_tid,
                               @"fid":self.threadModel.fid,
                               @"pid":self.threadModel.pid,
                               };
        NSDictionary *postDic = @{@"tid":_tid,
                                  @"fid":self.threadModel.fid,
                                  @"pid":self.threadModel.pid,
                                  @"activitycancel":@"true",
                                  @"formhash":[Environment sharedEnvironment].formhash
                                  };
        request.methodType = JTMethodTypePOST;
        request.urlString = url_ActivityApplies;
        request.parameters = postDic;
        request.getParam = dic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        NSString *messagestr = [responseObject messagestr];
        if ([[responseObject messageval] containsString:@"_success"]) {
            [MBProgressHUD showInfo:messagestr];
            self.currentPageId = 1;
            [self newDownLoadData];
            return;
        }
        [MBProgressHUD showInfo:messagestr];
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}


#pragma mark  - 举报
-(void)createComplain{
    if (![self isLogin]) {
        return;
    }
    
    [self createComplainView];
}

- (void)loginedReshData {
    self.currentPageId = 1;
    [self newDownLoadData];
}

- (void)createComplainView {
    [UIAlertController alertTitle:@"举报"
                          message:nil
                       controller:self
                      doneTextArr:@[@"广告垃圾",@"违规内容",@"恶意灌水",@"重复发帖"]
                       cancelText:@"取消"
                       doneHandle:^(NSInteger index) {
                           switch (index) {
                               case 0:
                                   [self createPostjb:@"广告垃圾"];
                                   break;
                               case 1:
                                   [self createPostjb:@"违规内容"];
                                   break;
                               case 2:
                                   [self createPostjb:@"恶意灌水"];
                                   break;
                               case 3:
                                   [self createPostjb:@"重复发帖"];
                                   break;
                               default:
                                   break;
                                   
                           }
                       } cancelHandle:^{
                           self.jubaoPid = nil;
                       }];
}

#pragma mark - 提交举报
-(void)createPostjb:(NSString *)str {
    NSString * strjubao;
    if (![DataCheck isValidString:self.jubaoPid]) {
        strjubao = self.threadModel.pid;
    } else {
        strjubao = self.jubaoPid;
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        
        NSDictionary * dic = @{@"formhash":[Environment sharedEnvironment].formhash,
                               @"reportsubmit":@"true",
                               @"message":str,
                               @"rtype":@"post",
                               @"rid":strjubao,
                               @"fid":self.threadModel.fid,
                               @"inajax":@1,
                               };
        request.urlString = url_Report;
        request.parameters = dic;
        request.methodType = JTMethodTypePOST;
    } success:^(id responseObject, JTLoadType type) {
        if ([[responseObject messageval] containsString:@"succeed"]) {
            [MBProgressHUD showInfo:@"提交成功！"];
        } else {
            [MBProgressHUD showInfo:@"提交失败，请稍后再试"];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD showInfo:@"提交失败，请稍后再试"];
    }];
}

#pragma mark  - 查看参与投票人
-(void)createVisitVotesrs:(id)data {
    ViewPollPotionNumberViewController * vppnvc = [[ViewPollPotionNumberViewController alloc]init];
    vppnvc.tid=self.tid;
    [self.navigationController pushViewController:vppnvc animated:YES];
}

#pragma mark  -  查看用户详情
-(void)creatOterUserCenterVC:(id)data{
    if (![self isLogin]) {
        return;
    }
    
    if ([DataCheck isValidString:data]) {
        OtherUserController * ovc = [[OtherUserController alloc] init];
        ovc.authorid = (NSString *)data;
        [self.navigationController pushViewController:ovc animated:YES];
    }
}

#pragma  mark  -  参与投票
- (void)createPostVote:(id)data {
    if (![self isLogin]) {
        return;
    }
    
    if (![DataCheck isValidString:data]) {
        [MBProgressHUD showInfo:@"请选择投票选项"];
        return;
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSString * strUrl = [data stringByReplacingOccurrencesOfString:@"{" withString:@""];
        NSString * str1 = [strUrl stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSArray *pollanswers = [str1 componentsSeparatedByString:@"|"];
        
        NSDictionary * postdic=@{@"formhash":[Environment sharedEnvironment].formhash,
                                 @"pollanswers":pollanswers,
                                 };
        NSDictionary *getDic = @{@"fid":self.threadModel.fid,
                                 @"tid":self.tid,
                                 };
        
        request.methodType = JTMethodTypePOST;
        request.urlString = url_Pollvote;
        request.parameters = postdic;
        request.getParam = getDic;
    } success:^(id responseObject, JTLoadType type) {
        if ([[responseObject messageval] containsString:@"succeed"]) {
            [UIAlertController alertTitle:@"投票成功"
                                  message:@"是否查看投票结果"
                               controller:self
                                 doneText:@"确定"
                               cancelText:@"取消"
                               doneHandle:^{
                                   [self newDownLoadData];
                               } cancelHandle:nil];
        } else {
            [MBProgressHUD showInfo:[responseObject messagestr]];
        }
    } failed:^(NSError *error) {
        [self showServerError:error];
    }];
}


#pragma  mark  -  获取引用回复的内容包括HTML标签
- (void)ReferenceReply:(id)data textview:(YYTextView *)view {
    if (![self isLogin]) {
        return;
    }
    
    [view becomeFirstResponder];
    
    _reppid = (NSString *)data;
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary * dic =@{@"tid":self.tid,
                              @"repquote":(NSString*)data
                              };
        request.urlString = url_ReplyContent;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        
        NSString *messagestr = [[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"];
        if ([DataCheck isValidString:messagestr]) {
            [MBProgressHUD showInfo:messagestr];
        }
        _noticetrimstr = [[responseObject objectForKey:@"Variables"]objectForKey:@"noticetrimstr"];
        
        _isReferenceReply = YES;
        
    } failed:^(NSError *error) {
    }];
}

#pragma  mark  -  点赞
-(void)createPraise:(id)data {
    if (![self isLogin]) {
        return;
    }
    if ([self.threadModel.recommend isEqualToString:@"1"]) {
        [MBProgressHUD showInfo:@"您已赞过该主题"];
    } else {
        
        [PraiseHelper praiseRequestTid:self.threadModel.tid successBlock:^{
            [self.HUD hide];
            [self.detailView.emoKeyboard.textBarView.praiseBtn setBackgroundImage:[UIImage imageNamed:@"bar_zans"] forState:UIControlStateNormal];
            self.threadModel.recommend = @"1";
            [self.detailView.webView stringByEvaluatingJavaScriptFromString:@"onPraiseSuccess()"];
        } failureBlock:^(NSError *error) {
            [self.HUD hide];
            [self showServerError:error];
        }];
    }
}

#pragma  mark  -  分享
- (void)shareBarClick:(UIButton *)sender {
    [self shareSome];
}

- (void)shareSome {
    NSMutableArray * imageArray = [[NSMutableArray alloc] init];
    if ([DataCheck isValidString:self.threadModel.shareImageUrl]) {
        [imageArray addObject:self.threadModel.shareImageUrl];
    }else{
        NSString *iconName = [DZDevice getIconName];
        [imageArray addObject:[UIImage imageNamed:iconName]];
    }
    NSString *threadtitle = self.threadModel.subject;
    NSString *dateline = self.threadModel.dateline;
    NSString *authorname = self.threadModel.author;
    NSString *shareContent = [NSString stringWithFormat:@"作者：%@ 发表于：%@",authorname,dateline];
    [[ShareCenter shareInstance] createShare:shareContent
                                   andImages:imageArray
                                   andUrlstr:self.threadModel.shareUrl
                                    andTitle:threadtitle
                                     andView:self.view
                                      andHUD:self.HUD];
}

#pragma mark - 帖子收藏
-(void)rightBarClick:(UIButton*)btn {

    if (![self isLogin]) {
        return;
    }
    NSDictionary * getdic=@{@"id":self.tid};
    NSDictionary * dic=@{@"formhash":[Environment sharedEnvironment].formhash};
    if (btn.tag == 100001) {
        [[CollectionTool shareInstance] collectionThread:getdic andPostdic:dic success:^{
            [self.HUD hide];
            [self setIsCollection:btn];
        } failure:nil];
        
    } else if (btn.tag==100002) {
        
        NSDictionary *getDic = @{@"id":self.tid,
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

// 设置收藏的状态
- (void)setNotCollection:(UIButton *)btn {
    [btn setBackgroundImage:[UIImage imageNamed:@"bar_xing"] forState:UIControlStateNormal];
    btn.tag=100001;
}

- (void)setIsCollection:(UIButton *)btn {
    [btn setBackgroundImage:[UIImage imageNamed:@"bar_xings"] forState:UIControlStateNormal];
    btn.tag=100002;
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"post" success:^{
        if (self.verifyView.isyanzhengma) {
            [self.verifyView show];
        } else {
            [self postReplay];
        }
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
    
    WEAKSELF;
    self.verifyView.submitBlock = ^{
        [weakSelf postReplay];
    };
}


#pragma mark  -  下载数据
-(void)newDownLoadData {
    static NSInteger requestCount = 0;
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{@"tid":self.tid,
                              @"page":[NSString stringWithFormat:@"%d",self.currentPageId]
                              };
        if (self.currentPageId == 1) {
            [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
        }
        self.threadModel.tid = self.tid;
        request.urlString = url_ThreadDetail;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        requestCount = 0;
        BOOL haveAuther = [ResponseMessage autherityJudgeResponseObject:responseObject refuseBlock:^(NSString *message) {
            [UIAlertController alertTitle:nil message:message  controller:self doneText:@"确定" cancelText:nil doneHandle:^{
                [self.navigationController popViewControllerAnimated:YES];
            } cancelHandle:nil];
            [self.HUD hide];
        }];
        if (!haveAuther) {
            return;
        }
        
        [self emptyHide];
        self.threadModel.currentPage = self.currentPageId;
        
        if (self.currentPageId == 1) {
            
            [self.detailView.webView.scrollView.mj_header endRefreshing];
            [self.detailView.webView.scrollView.mj_footer resetNoMoreData];
            
            self.threadModel.threadDic = responseObject;
            
            NSString *forumnames = [[[responseObject objectForKey:@"Variables"] objectForKey:@"thread"] objectForKey:@"forumnames"];
            if ([DataCheck isValidString:forumnames]) {
                self.title = forumnames;
            }
            
            if ([LoginModule isLogged]) {
                if ([self.threadModel.favorited isEqualToString:@"1"]) {
                    [self setIsCollection:self.detailView.emoKeyboard.textBarView.collectionBtn];
                    
                } else {
                    [self setNotCollection:self.detailView.emoKeyboard.textBarView.collectionBtn];
                }
                
                if ([self.threadModel.recommend isEqualToString:@"1"]) {
                    [self.detailView.emoKeyboard.textBarView.praiseBtn setBackgroundImage:[UIImage imageNamed:@"bar_zans"] forState:UIControlStateNormal];
                }
            }
            
            self.threadModel.isRequest = YES;
            if (self.threadModel.replies + 1 <= self.threadModel.ppp) {
                [self.detailView.webView.scrollView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.detailView.webView loadRequest:[NSURLRequest requestWithURL:self.threadModel.baseUrl]];
            
        } else {
            
            [self.detailView.webView.scrollView.mj_footer endRefreshing];
            self.threadModel.threadDic = responseObject;
            NSArray *postlist = [[responseObject objectForKey:@"Variables"] objectForKey:@"postlist"];
            if (![DataCheck isValidArray:postlist])
            {
                self.currentPageId --;
                [MBProgressHUD showInfo:@"没有更多的帖子了"];
                [self.detailView.webView.scrollView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            // 下一页json字符串
            NSString *addJsonStr= [[NSString alloc] initWithData:self.threadModel.jsonData encoding:NSUTF8StringEncoding];
            // 加载评论 true 是否时分页
            [self.detailView.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onLoadReply(%@,true)",addJsonStr]];
            
            if(self.threadModel.replies  < self.threadModel.ppp * (_currentPageId)){
                
                if (self.currentPageId > 0) {
                    [self.detailView.webView.scrollView.mj_footer endRefreshingWithNoMoreData];
                    self.currentPageId --;
                }
            }
        }
        
    } failed:^(NSError *error) {
        [self.detailView.webView.scrollView.mj_header endRefreshing];
        [self.detailView.webView.scrollView.mj_footer endRefreshing];
        if (requestCount == 0) {
            [self newDownLoadData];
            requestCount ++;
        } else {
            if (self.currentPageId > 1) {
                self.currentPageId --;
            }
            else {
                [self emptyShow];
            }
            self.threadModel.currentPage = self.currentPageId;
            [self.HUD hide];
            [self showServerError:error];
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString isEqualToString:self.threadModel.baseUrl.absoluteString]) {
        if (self.currentPageId == 1) {
            NSString *jsonStr = [[NSString alloc] initWithData:self.threadModel.jsonData encoding:NSUTF8StringEncoding];
            BOOL activitie = NO;
            if ([DataCheck isValidString:self.threadModel.specialString] && [self.threadModel.specialString isEqualToString:@"4"]) {
                activitie= YES;
            }
            if (self.threadModel.isRequest == YES) {
                NSString *noimage = [JudgeImageModel graphFreeModel] == YES ? @"false" : @"true";
                if (activitie) {
                    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"onRefresh(%@,%@,%@)",jsonStr,self.threadModel.isActivity?@"false":@"true",noimage]];
                }else {
                    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"onRefresh(%@,true,%@)",jsonStr,noimage]];
                }
                self.threadModel.isRequest = NO;
            }
            webView.frame=CGRectMake(0, 0, WIDTH, HEIGHT - 50);
            [self.HUD hide];
        }
    }
}

- (void)emptyShow {
    self.emptyView.hidden = NO;
    self.emptyView.frame = self.view.frame;
    self.detailView.emoKeyboard.hidden = YES;
    self.detailView.webView.scrollView.mj_footer.hidden = YES;
}

- (void)emptyHide {
    self.emptyView.hidden = YES;
    self.detailView.emoKeyboard.hidden = NO;
    self.detailView.webView.scrollView.mj_footer.hidden = NO;
}


#pragma mark - 回复帖子
-(void)postReplay{
    if (![self isLogin]) {
        return;
    }
//    if ([DataCheck isValidString:self.threadModel.allowpost]&&[self.threadModel.allowpost isEqualToString:@"0"]) {
//        [MBProgressHUD showInfo:@"暂无发帖权限"];
//        return;
//    }
    //begain回复
    
    if (![DataCheck isValidString:self.detailView.emoKeyboard.textBarView.textView.text]) {
        [UIAlertController alertTitle:@"请不要回复空帖" message:nil controller:self doneText:@"OK" cancelText:nil doneHandle:nil cancelHandle:nil];
        [self.detailView.emoKeyboard.textBarView.textView resignFirstResponder];
        return;
    }

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.detailView.emoKeyboard.textBarView.textView.text forKey:@"message"];
    [dic setObject:[Environment sharedEnvironment].formhash forKey:@"formhash"];
    [dic setObject:self.threadModel.tid  forKey:@"tid"];
    // 引用回复 post 增加 两个参数
    if (_isReferenceReply) {
        [dic setObject:_noticetrimstr forKey:@"noticetrimstr"];
        [dic setObject:_reppid forKey:@"reppid"];
    }
    
    if (self.verifyView.isyanzhengma) {
        [dic setObject:self.verifyView.yanTextField.text forKey:@"seccodeverify"];
        [dic setObject:[self.verifyView.secureData objectForKey:@"sechash"] forKey:@"sechash"];
        if ([DataCheck isValidString:[self.verifyView.secureData objectForKey:@"secqaa"]]) {
            [dic setObject:self.verifyView.secTextField.text forKey:@"secanswer"];
        }
    }
    
    if (self.preSalkey) {
        [dic setObject:self.preSalkey forKey:@"saltkey"];
    }
    
    NSArray *aidArr = self.detailView.emoKeyboard.uploadView.uploadModel.aidArray;
    if (aidArr.count > 0) {
        for (int i=0; i < aidArr.count; i++){
            NSString *description = @"";
            [dic setObject:description forKey:[NSString stringWithFormat:@"attachnew[%@][description]",[aidArr objectAtIndex:i]]];
        }
    }
   
    [self sendReply:dic];
}

- (void)sendReply:(NSDictionary *)dic {

    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"发帖中..." toView:self.view];
        request.methodType = JTMethodTypePOST;
        request.urlString = url_Sendreply;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        NSDictionary *messageDic = [responseObject objectForKey:@"Message"];
        NSString *messagestr = [messageDic objectForKey:@"messagestr"];
        NSString *messageval = [messageDic objectForKey:@"messageval"];
        if ([DataCheck isValidString:messageval]) {

            if ([messageval containsString:@"succeed"] || [messageval containsString:@"success"]) {
                _isReferenceReply = NO;
                
                [self.detailView.emoKeyboard clearData];
                
                if (![messagestr containsString:@"审核"]) {
                    [MBProgressHUD showInfo:@"回帖成功"];
                    if (_currentPageId==1) {
                        if (self.threadModel.replies + 1 < self.threadModel.ppp - 1) {
                            //                        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onDiscussSuccess(%@,true,%@,%@)",_strJSONData,self.isnoimage,pid]];
                            //                        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onLoadReply(%@,true)",_strJSONData]];
                            [self newDownLoadData];
                        }
                    }
                } else {
                    [MBProgressHUD showInfo:messagestr];
                }
            }
            else {
                [MBProgressHUD showInfo:messagestr];
                if ([messageval isEqualToString:@"post_sm_isnull"]) {
                    self.detailView.emoKeyboard.textBarView.textView.text = nil;
                }
            }
        } else {
            [MBProgressHUD showInfo:@"回帖失败"];
        }
        [self.HUD hide];

    } failed:^(NSError *error) {
        [self showServerError:error];
        [self.HUD hide];
    }];
}

#pragma mark 点击状态栏到顶部
- (void)statusBarTappedAction:(NSNotification*)notification {
    [self.detailView.webView.scrollView setContentOffset:CGPointMake(0, -self.navbarMaxY) animated:YES];
}

#pragma mark - 滚动webView的时候收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.detailView.emoKeyboard hideCustomerKeyBoard];
}

#pragma mark -  键盘代理发送sendAction
-(void)sendAction{
    
    [self.detailView.emoKeyboard hideCustomerKeyBoard];
    if (![self isLogin]) {
        return;
    }
    [self downlodyan];
}

#pragma mark - getter
- (SeccodeverifyView *)verifyView {
    if (!_verifyView) {
        _verifyView = [[SeccodeverifyView alloc] init];
    }
    return _verifyView;
}

- (ThreadModel *)threadModel {
    if (!_threadModel) {
        _threadModel = [[ThreadModel alloc] init];
    }
    return _threadModel;
}

@end

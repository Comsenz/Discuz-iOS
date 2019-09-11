//
//  ChatDetailController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "ChatDetailController.h"
#import "MessageModel.h"
#import "EmoticonKeyboard.h"
#import "LoginController.h"
#import "LoginModule.h"
#import "ChatContentCell.h"

#import "OtherUserController.h"

@interface ChatDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat kToolBarH;
}

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) NSInteger pressIndexRow;

@property (nonatomic, strong) NSMutableDictionary *sourceDic;
@property (nonatomic, strong) NSMutableArray<MessageModel *> *messageModelArr;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;  // 缓存cell高度
// 表情键盘
@property (nonatomic, strong) EmoticonKeyboard *emoKeyboard;

@end

@implementation ChatDetailController

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        [self.emoKeyboard hideCustomerKeyBoard];
    }
    [super willMoveToParentViewController:parent];
}

/**
 *  添加TableView
 */
- (void)addChatView {
    self.chatTableView = [[UITableView alloc] init];
    self.chatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kToolBarH);
    self.chatTableView.backgroundColor = [UIColor whiteColor];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.chatTableView];
}

/**
 *  点击聊天界面收起键盘
 */
- (void)endEdit {
    [self.emoKeyboard hideCustomerKeyBoard];
    [self restoreChatView];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.username;
    
    kToolBarH = 50;
    
    kToolBarH = 50 + SafeAreaBottomHeight;
    
    // 加自定义表情键盘必须添加这行代码。
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    // 添加聊天tableview
    [self addChatView];
    
    // 刷新方法
    _page=0;
    _isRefresh=YES;
    [self refreshMethod];
    
    [self loadData:[NSString stringWithFormat:@"%ld",(long)self.page]];
    
    // 表情输入框
    [self createHPGrowingTextView];
}

#pragma mark - 请求方法
- (void)refreshMethod {
    WEAKSELF;
    // 页数
    self.chatTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"刷新");
        [weakSelf.chatTableView.mj_header endRefreshing];
        
        if (weakSelf.isRefresh == YES || weakSelf.page > 0) {
            [weakSelf updateData];
            weakSelf.page -- ;
        } else if (weakSelf.page == 0) {
            NSLog(@"无数据");
            [MBProgressHUD showInfo:@"没有更多回复"];
        }
    }];
    
}

#pragma mark -  创建表情键盘
- (EmoticonKeyboard *)emoKeyboard {
    if (_emoKeyboard == nil) {
        //        CGRect fr = CGRectMake(0, 0, WIDTH, HEIGHT - 67);
        CGFloat tabbarH = 50;
        _emoKeyboard = [[EmoticonKeyboard alloc] initWithFrame:CGRectMake(0, HEIGHT - tabbarH - SafeAreaBottomHeight, WIDTH, tabbarH)];
    }
    return _emoKeyboard;
}

- (void)createHPGrowingTextView{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addSubview:self.emoKeyboard];
    self.emoKeyboard.backgroundColor = MAIN_GRAY_COLOR;
    self.emoKeyboard.textBarView.style = chat_textBar;
    _emoKeyboard.textBarView.textView.placeholderText = @"回复消息";
    [_emoKeyboard.textBarView.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    WEAKSELF;
    
    self.emoKeyboard.sendBlock = ^ {
        [weakSelf sendAction];
    };
    
    self.emoKeyboard.textBarView.sendMessageBlock = ^ {
        [weakSelf sendAction];
    };
    
    self.emoKeyboard.showBlock = ^(CGFloat height) {
        [weakSelf keyboardShowChatViewScroll:height];
    };
    
    self.emoKeyboard.changeBlock = ^(CGFloat eveheight, CGFloat height) {
        NSTimeInterval animationDuration = BShowTime;
        [weakSelf chatViewScrollAnimation:animationDuration andOffsetY:CGRectGetMinY(weakSelf.chatTableView.frame) - eveheight];
    };
}

#pragma mark -  键盘sendAction
-(void)sendAction{
    [self.emoKeyboard hideCustomerKeyBoard];
    [self restoreChatView];
    [self postBtnClick:nil];
}

- (void)restoreChatView {
    
    if (!self.emoKeyboard.imageboaudIsShow) {
        [UIView animateWithDuration:BShowTime animations:^{
            self.chatTableView.frame = CGRectMake(0, 0 - self.emoKeyboard.ChangeHeight, self.view.frame.size.width, self.view.frame.size.height - kToolBarH);
        }];
    }
}

////当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    height += self.emoKeyboard.ChangeHeight;
    [self keyboardShowChatViewScroll:height];
    
}

- (void)chatViewScrollAnimation:(NSTimeInterval)duration andOffsetY:(CGFloat)offsetY {
    CGRect frame = self.chatTableView.frame;
    CGRect rect = CGRectMake(0.0,offsetY,frame.size.width,frame.size.height);
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:duration];
    self.chatTableView.frame = rect;
    [UIView commitAnimations];
}

/**
 键盘升起，界面滚动避免遮挡
 
 @param customKeyboardHeight 自定义键盘高度
 */
- (void)keyboardShowChatViewScroll:(CGFloat)customKeyboardHeight {
    NSTimeInterval animationDuration = BShowTime;

    if (self.messageModelArr.count > 0) {
        
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messageModelArr.count - 1 inSection:0];
        [self.chatTableView visibleCells];
        UITableViewCell *lastCell = [self.chatTableView cellForRowAtIndexPath:lastIndexPath];
        
        if ([self.chatTableView.visibleCells containsObject:lastCell]) {
            
            CGRect lastFrame = lastCell.frame;
            CGFloat offsetY = CGRectGetMaxY(lastFrame) - (HEIGHT - customKeyboardHeight);
            if (offsetY > 0) {
                [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                [self chatViewScrollAnimation:animationDuration andOffsetY: -customKeyboardHeight];
            }
        } else {
            
            [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self chatViewScrollAnimation:0 andOffsetY: -customKeyboardHeight];
        }
    }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self restoreChatView];
}

/**
 *  加载数据
 */
- (void)loadData:(NSString *)page {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
        NSDictionary * postdic = @{@"touid":self.touid,
                                   @"page":[NSString stringWithFormat:@"%ld",(long)_page]};
        request.urlString = url_MessageDetail;
        request.methodType = JTMethodTypePOST;
        request.parameters = postdic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        self.sourceDic = [responseObject objectForKey:@"Variables"];
        NSArray * dataArray = [[responseObject objectForKey:@"Variables"] objectForKey:@"list"];
        if (_isRefresh) {
            [self.messageModelArr removeAllObjects];
            self.page = [[self.sourceDic objectForKey:@"page"] integerValue] - 1;
            
        }
        // 每次刷新的内容插入到数组最前面，放在顶端，使之前的展示在用户可视范围内
        int i = 0;
        for (NSMutableDictionary * dict in dataArray) {//msgfromid   authorid
            NSMutableDictionary  * newDic = [NSMutableDictionary dictionaryWithDictionary:dict];
            if ([[newDic objectForKey:@"msgfromid"] isEqualToString:[LoginModule getLoggedUid]]) {
                [newDic setValue:@"0" forKey:@"type"];
            } else {
                [newDic setValue:@"1" forKey:@"type"];
            }
            MessageModel * message = [MessageModel messageModelWithDict:newDic];
            [self.messageModelArr insertObject:message atIndex:i];
            i++;
        }
        [self.chatTableView reloadData];
        
        if (self.messageModelArr.count > 0) {
            if (_isRefresh) {
                self.isRefresh=NO; // 必须写，重要 首页的时候滚动到最底部
                NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:self.messageModelArr.count - 1 inSection:0];
                [self.chatTableView scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
            }
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}

- (void)updateData {
    [self.cellHeights removeAllObjects];
    [self loadData:[NSString stringWithFormat:@"%ld",(long)self.page]];
}

-(void)postBtnClick:(UIButton *)btn {
    NSString *messagestr = self.emoKeyboard.textBarView.textView.text;
    if (![DataCheck isValidString:messagestr]) {
        return;
    }
    
    NSDictionary * dic = @{@"formhash":[Environment sharedEnvironment].formhash,
                           @"message":messagestr,
                           @"username":self.username,
                           @"touid":self.touid
                           };
    
    NSDictionary * getdic = @{@"touid":self.touid,
                              @"pmid":@"0"
                              };
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"" toView:nil];
        request.methodType = JTMethodTypePOST;
        request.urlString = url_Sendpm;
        request.parameters = dic;
        request.getParam = getdic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        NSString *messageval = [responseObject messageval];
        NSString *messagestr = [responseObject messagestr];
        if ([messageval containsString:@"succeed"] || [messageval containsString:@"success"])  {
            [MBProgressHUD showInfo:@"发送成功"];
            self.page = 0;
            _isRefresh = YES;
            [self performSelector:@selector(updateData) withObject:nil afterDelay:1];
            self.emoKeyboard.textBarView.textView.text = @"";
            
        } else {
            NSString *tip = @"发消息的时间间隔小于15秒，请稍后再试";
            if ([DataCheck isValidString:messagestr]) {
                tip = messagestr;
            }
            [MBProgressHUD showInfo:tip];
        }
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatcontent"];
    if (cell == nil) {
        cell = [[ChatContentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"chatcontent"];
    }
    
    UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longAction:)];
    [cell.messageLabel addGestureRecognizer:longGesture];
    cell.messageModel = self.messageModelArr[indexPath.row];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOtherCenter:)];
    cell.headView.tag = indexPath.row;
    [cell.headView addGestureRecognizer:tap];
    
    return cell;
}

- (void)goOtherCenter:(UITapGestureRecognizer *)sender {
    
    UIView *view = sender.view;
    MessageModel *model = self.messageModelArr[view.tag];
    OtherUserController *ovc = [[OtherUserController alloc] init];
    ovc.authorid = model.authorid;
    [self showViewController:ovc sender:nil];
    
}

//长按触发的事件
- (void)longAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *pressedIndexPath = [self.chatTableView indexPathForRowAtPoint:[sender locationInView:self.chatTableView]];
        
        ChatContentCell *cell = [self.chatTableView cellForRowAtIndexPath:pressedIndexPath];
        //一定要调用这个方法
        [cell.messageLabel becomeFirstResponder];
        //创建菜单控制器
        UIMenuController * menuvc = [UIMenuController sharedMenuController];
        UIMenuItem * menuItem = [[UIMenuItem alloc]initWithTitle:@"拷贝" action:@selector(copyAction)];
        UIMenuItem * menuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteAction)];
        menuvc.menuItems = @[menuItem,menuItem1];
        [menuvc setTargetRect:CGRectMake(cell.messageLabel.bounds.size.width/2, cell.messageLabel.bounds.origin.y, 0, 0) inView:cell.messageLabel];
        [menuvc setMenuVisible:YES animated:YES];
        
        self.pressIndexRow = pressedIndexPath.row;
        WEAKSELF;
        cell.messageLabel.copyBlock = ^{
            [weakSelf copyText];
        };
        cell.messageLabel.deleteBlock = ^{
            [weakSelf deleteMessage];
        };
        
    }
}

// 只为了消除烦人的警告
- (void)copyAction {}
- (void)deleteAction {}

- (void)deleteMessage {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        MessageModel *message = self.messageModelArr[self.pressIndexRow];
        NSDictionary *parameters = @{@"id":message.touid,
                                     @"formhash":[Environment sharedEnvironment].formhash,
                                     @"pid":message.pmid};
        request.urlString = url_DeleteOneMessage;
        request.methodType = JTMethodTypePOST;
        request.parameters = parameters;
    } success:^(id responseObject, JTLoadType type) {
        NSString *messageval = [responseObject messageval];
        
        if ([messageval containsString:@"succeed"] || [messageval containsString:@"success"]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.pressIndexRow inSection:0];
            [self.messageModelArr removeObjectAtIndex:self.pressIndexRow];
            [self.cellHeights removeAllObjects];
            [self.chatTableView beginUpdates];
            [self.chatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.chatTableView endUpdates];
        } else {
            [MBProgressHUD showInfo:@"删除失败"];
        }
        
    } failed:^(NSError *error) {
        [self showServerError:error];
    }];
}

- (void)copyText {
    MessageModel *message = self.messageModelArr[self.pressIndexRow];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:message.text];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self endEdit];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.cellHeights[indexPath]) {
        self.cellHeights[indexPath] = @([self heightForRowAtIndexPath:indexPath tableView:tableView]);
    }
    return [self.cellHeights[indexPath] floatValue];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat height =[(ChatContentCell *)cell cellHeight];
    return height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.emoKeyboard hideCustomerKeyBoard];
    [self restoreChatView];
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray<MessageModel *> *)messageModelArr {
    if (!_messageModelArr) {
        _messageModelArr = [NSMutableArray array];
    }
    return _messageModelArr;
}

- (NSMutableDictionary *)sourceDic {
    if (!_sourceDic) {
        _sourceDic = [NSMutableDictionary dictionary];
    }
    return _sourceDic;
}

- (NSMutableDictionary *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableDictionary dictionary];
    }
    return _cellHeights;
}

@end

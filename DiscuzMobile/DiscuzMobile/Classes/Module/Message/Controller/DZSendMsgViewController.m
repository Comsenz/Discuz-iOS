//
//  DZSendMsgViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/12.
//  Copyright (c) 2015年 comsenz-service.com. All rights reserved.
//

#import "DZSendMsgViewController.h"

@interface DZSendMsgViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@end

@implementation DZSendMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发送消息";
    [self initUI];
    if ([DataCheck isValidString:self.uid]) {
        [self createBarBtn:@"取消" type:NavItemText Direction:NavDirectionLeft];
    }
}

-(void)leftBarBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initUI{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    [_bgScrollView setShowsHorizontalScrollIndicator:NO];
    [_bgScrollView setShowsVerticalScrollIndicator:NO];
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.delegate = self;
    [self.view addSubview:_bgScrollView];
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 55)];
    userView.backgroundColor = [UIColor whiteColor];
    
    UILabel *peopleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 80, 15)];
    peopleLable.text = @"收件人：";
    peopleLable.font = [DZFontSize forumtimeFontSize14];// 14-15
    [userView addSubview:peopleLable];
    
    self.titleTextField =[[UITextField alloc] initWithFrame:CGRectMake(peopleLable.frame.size.width +peopleLable.frame.origin.x +10,5, KScreenWidth, 45)];
    self.titleTextField.placeholder = @"请输入用户名";
    self.titleTextField.font = [DZFontSize HomecellTitleFontSize17];
    self.titleTextField.delegate = self;
    
    if ([DataCheck isValidString:self.uid]) {
        self.titleTextField.text = self.uid;
    }
    [userView addSubview:self.titleTextField];
    
    [_bgScrollView addSubview:userView];
    
    UIView * messageView = [[UIView alloc] initWithFrame:CGRectMake(0, userView.frame.size.height +userView.frame.origin.y +10,KScreenWidth, 160)];
    messageView.backgroundColor = [UIColor whiteColor];
    
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10,KScreenWidth-20, 140)];
    self.messageTextView.delegate = self;
    self.messageTextView.font =[DZFontSize HomecellTitleFontSize17];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, KScreenWidth-40, 15)];
    self.placeholderLabel.numberOfLines =0;
    self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
    self.placeholderLabel.text =@"请输入短消息的内容";
    self.placeholderLabel.font = [DZFontSize HomecellTitleFontSize17];
    self.placeholderLabel.textColor =mRGBColor(211, 211, 211);
    
    [self.messageTextView addSubview:self.placeholderLabel];
    
    [messageView addSubview:self.messageTextView];
    [_bgScrollView addSubview:messageView];
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setTitle:@"发送" forState:UIControlStateNormal];
    [postBtn setBackgroundColor:K_Color_Theme];
    [postBtn addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
    postBtn.frame = CGRectMake(10, messageView.frame.origin.y +messageView.frame.size.height +20 ,KScreenWidth -20, 40);
    postBtn.layer.cornerRadius  = 4.0;
    postBtn.layer.borderWidth = 1.0;
    postBtn.layer.borderColor = K_Color_Theme.CGColor;
   
    [_bgScrollView addSubview:postBtn];
}

-(void)postData{
    
    if (![self isLogin]) {
        return;
    }
    if(![DataCheck isValidString:self.messageTextView.text]){
        [MBProgressHUD showInfo:@"消息内容为空"];
        return;
    }
    if(![DataCheck isValidString:self.titleTextField.text]){
        [MBProgressHUD showInfo:@"用户名内容为空"];
        return;
    }

    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"发送中" toView:self.view];
        NSDictionary * dic = @{@"formhash":[Environment sharedEnvironment].formhash,
                               @"message":self.messageTextView.text,
                               @"username":self.titleTextField.text};
        
        NSDictionary * getdic = @{@"touid":@"0",
                                  @"pmid":@"0"};
        request.urlString = DZ_Url_Sendpm;
        request.methodType = JTMethodTypePOST;
        request.parameters = dic;
        request.getParam = getdic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        NSString *stauts = [responseObject messageval];
        NSString *msg = [responseObject messagestr];
        [MBProgressHUD showInfo:msg];
        if ([stauts isEqualToString:@"do_success"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.messageTextView.text = nil;
        self.placeholderLabel.hidden = NO;
        self.titleTextField.text = nil;
    } failed:^(NSError *error) {
        [self showServerError:error];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_bgScrollView endEditing:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text hasEmoji]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (![textView.text isEqualToString:@""]) {
        
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.messageTextView resignFirstResponder];
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_bgScrollView endEditing:YES];
}

@end

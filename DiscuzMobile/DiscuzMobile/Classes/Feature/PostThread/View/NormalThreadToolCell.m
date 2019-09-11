//
//  NormalThreadToolCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "NormalThreadToolCell.h"
#import "AudioManager.h"

@implementation NormalThreadToolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (void)p_setupViews {
    
    // 创建 barbutton
    self.postImgViwe = [[UIView alloc] initWithFrame:CGRectMake(0,0, WIDTH, 50)];
    self.postImgViwe.backgroundColor = mRGBColor(252, 252, 252);
    [self.contentView addSubview:self.postImgViwe];
    
    UIButton *expressionBtn = [self functionBtn:@"expression" andTag:200];
    [self.postImgViwe addSubview:expressionBtn];
    
    UIButton *imgBtn = [self functionBtn:@"camera" andTag:201];
    [self.postImgViwe addSubview:imgBtn];
    
    UIButton *recordBtn = [self functionBtn:@"record" andTag:202];
    [self.postImgViwe addSubview:recordBtn];
    
    
    self.controlScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.postImgViwe.frame), WIDTH, 216)];
    self.controlScrollView.contentSize = CGSizeMake(WIDTH * 3, 216);
    self.controlScrollView.scrollEnabled = NO;
    [self.contentView addSubview:self.controlScrollView];
    
    
    // 创建表情 view
    WBEmoticonInputView *v = [WBEmoticonInputView sharedView];
    v.frame = CGRectMake(0, 50, WIDTH, 216);
    v.hidden = NO;
    [self addSubview:v];
    
    // 创建上传图片 view
    [self setupPickerView];
    
    
    // 创建录音
    self.recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(WIDTH * 2, 0, WIDTH, 200 + 30)];
    [AudioManager setAudioTool:self.recordView];
    [self.controlScrollView addSubview:self.recordView];
}

- (void)setupPickerView {
    self.uploadView = [[UploadAttachView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, 216-45)];
    [self.controlScrollView addSubview:self.uploadView];
}

- (UIButton *)functionBtn:(NSString *)icon andTag:(NSInteger)tag {
    CGFloat btn_width = 34;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15 + (btn_width + 15) * (tag - 200), 5, btn_width, btn_width);
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)buttonClick:(UIButton*)btn {
    
    if (self.hideKeyboardBlock) {
        self.hideKeyboardBlock();
    }
    WBEmoticonInputView *v = [WBEmoticonInputView sharedView];
    
    v.hidden = YES;
    if (btn.tag == 202) {
        self.controlScrollView.contentOffset = CGPointMake(WIDTH * 2, 0);
    }
    else if (btn.tag==201) {
        self.controlScrollView.contentOffset = CGPointMake(WIDTH, 0);
    }
    else if(btn.tag==200){
        v.hidden = NO;
        self.controlScrollView.contentOffset = CGPointMake(0, 0);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

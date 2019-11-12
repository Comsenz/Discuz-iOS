//
//  TPBaseNavigationBarViewController.m
//  PandaReader
//
//  Created by WebersonGao on 2019/4/4.
//  Copyright © 2019 ZHWenXue. All rights reserved.
//

#import "TPBaseNavigationBarViewController.h"
#import "TPNavItemButton.h"

#import "UIBarButtonItem+TPBarButtonItem.h"

@interface TPBaseNavigationBarViewController ()


@end

@implementation TPBaseNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self p_SetNavigationBar];
}

- (TPNavigationBar *)tp_NavigationBar{
    
    if (!_tp_NavigationBar) {
        
        _tp_NavigationBar = [[TPNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KNavigation_ContainStatusBar_Height)];
    }
    return _tp_NavigationBar;
}

- (UINavigationItem *)tp_NavigationItem{
    
    if (!_tp_NavigationItem) {
        _tp_NavigationItem = [[UINavigationItem alloc] init];
    }
    return _tp_NavigationItem;
}

//重写系统设置title的setter
- (void)setTitle:(NSString *)title {
    //正常创建控制器是先执行[alloc init] 后执行这句 在执行时在给予赋值
    if (!_normalTitle) {
        self.tp_NavigationItem.title = title;
    } else {
        [super setTitle:title];
    }
}

#pragma mark -设置导航栏
- (void)p_SetNavigationBar {
    
    [self.view addSubview:self.tp_NavigationBar];

    //将导航条目 添加到导航条
    self.tp_NavigationBar.items = @[self.tp_NavigationItem];
    
    //导航条的渲染颜色
    self.tp_NavigationBar.barTintColor = [UIColor color16WithHexString:@"#FFFFFF" alpha:1];
    
    UIFont *font = KExtraBoldFont(17.0f);
    UIColor *color = [UIColor color16WithHexString:@"#2D3035" alpha:1];
    //设置 bar 的标题字体颜色
    self.tp_NavigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : color, NSFontAttributeName : font};
    
}

- (void)setIsHiddenNavigationBar:(BOOL)isHiddenNavigationBar {
    


    
    _isHiddenNavigationBar = isHiddenNavigationBar;
    self.tp_NavigationBar.hidden = isHiddenNavigationBar;
}

- (void)tp_HiddenNavigationBarAndShowBackBtn:(BOOL)isShow {
    
    self.tp_NavigationBar.hidden = YES;
    
    if (isShow) {
        //创建btn
        TPNavItemButton *backBtn = [[TPNavItemButton alloc] initWithFrame:CGRectMake(8, KStatusBarHeight, 44, 44)];
        backBtn.isLeft = YES;
        [backBtn setImage:[UIImage imageNamed:@"reader_naviBack"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"reader_naviBack"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(p_ClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
}

- (void)p_ClickBackBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTp_NavigationAlpha:(CGFloat)tp_NavigationAlpha {
    
    _tp_NavigationAlpha = tp_NavigationAlpha;
    self.tp_NavigationBar.alpha = tp_NavigationAlpha;
}

- (void)setTp_BarTintColor:(UIColor *)tp_BarTintColor {
    
    _tp_BarTintColor = tp_BarTintColor;
    self.tp_NavigationBar.barTintColor = tp_BarTintColor;
}

- (void)setTp_BarTitleTextColor:(UIColor *)tp_BarTitleTextColor {
    
    _tp_BarTitleTextColor = tp_BarTitleTextColor;
    self.tp_NavigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : tp_BarTitleTextColor};
}

- (void)setTp_BarTitleFont:(UIFont *)tp_BarTitleFont {
    
    _tp_BarTitleFont = tp_BarTitleFont;
    self.tp_NavigationBar.titleTextAttributes = @{NSFontAttributeName : tp_BarTitleFont};
}

- (void)tp_SetNavigationBackItemWithTarget:(id)target action:(SEL)action {
    
    [self tp_SetNavigationItemWithInfoString:@"reader_naviBack" Type:TPNavigationItemType_Image Layout:YES FixSpace:YES target:target action:action];
}

- (void)tp_SetNavigationRightTextItemWithInfoString:(NSString *)infoStr target:(id)target action:(SEL)action {
    
    [self tp_SetNavigationItemWithInfoString:infoStr Type:TPNavigationItemType_Text Layout:NO FixSpace:YES target:target action:action];
}

- (void)tp_SetNavigationItemWithInfoString:(NSString *)infoStr Type:(TPNavigationItemType)type Layout:(BOOL)isLeft FixSpace:(BOOL)isFix target:(id)target action:(SEL)action {
    
    UIBarButtonItem *item;
    NSMutableArray *currentItems = [NSMutableArray arrayWithArray:isLeft ? self.tp_NavigationItem.leftBarButtonItems : self.tp_NavigationItem.rightBarButtonItems];
    
    if (type == TPNavigationItemType_Text) {
        item = [[UIBarButtonItem alloc] initWithItemTitle:infoStr Layout:isLeft target:target action:action];
    }
    
    if (type == TPNavigationItemType_Image) {
        item = [[UIBarButtonItem alloc] initWithItemImageName:infoStr Layout:isLeft target:target action:action];
    }
    
    if (isFix && !currentItems.count) {
        //为了缩进
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -5;
        [currentItems addObject:spaceItem];
    }
    
    if (!isLeft) {
        [currentItems insertObject:item atIndex:0];
    }else {
        [currentItems addObject:item];
    }
    [self tp_SetItems:[currentItems copy] Layout:isLeft];
}

- (void)p_SetItem:(UIBarButtonItem *)item Layout:(BOOL)isLeft {
    
    if (isLeft) {
        self.tp_NavigationItem.leftBarButtonItem = item;
    }else {
        self.tp_NavigationItem.rightBarButtonItem = item;
    }
}

- (void)tp_SetItems:(NSArray *)items Layout:(BOOL)isLeft {
    
    if (isLeft) {
        self.tp_NavigationItem.leftBarButtonItems = items;
    }else {
        self.tp_NavigationItem.rightBarButtonItems = items;
    }
}

- (void)tp_SetNavigationTitleView:(UIView *)titleView
{
    self.tp_NavigationItem.titleView = titleView;
}

- (void)tp_CancelScrollViewInsetWithTableView:(UITableView *)tableview {
    
    if (@available(iOS 11.0, *)) {
        tableview.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)tp_AddSubView:(UIView *)view belowNavigationBar:(BOOL)isBelow {
    
    if (isBelow) {
        [self.view insertSubview:view belowSubview:self.tp_NavigationBar];
    }else {
        [self.view insertSubview:view aboveSubview:self.tp_NavigationBar];
    }
}

- (void)tp_BaseControllerClickBackItem {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    DLog(@"释放类==%@",NSStringFromClass([self class]));
}


@end

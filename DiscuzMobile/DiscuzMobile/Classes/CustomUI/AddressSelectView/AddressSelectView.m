//
//  AddressSelectView.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "AddressSelectView.h"
#import "addressModel.h"
#import <MJExtension.h>

@interface AddressSelectView ()  <UIPickerViewDelegate,UIPickerViewDataSource>

{
    NSMutableArray *shengArray;
    NSMutableArray *shiArray;
    NSMutableArray *xianArray;
    
    UIPickerView *myPickerView;
    
    NSMutableDictionary *chooseDic;
}

@end

@implementation AddressSelectView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commitInit];
    }
    
    return self;
}

- (void)commitInit {
    
    self.backgroundColor = TOOLBAR_BACK_COLOR;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"]];
    
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *dataArray=dataDic[@"result"][0][@"son"];
    //    NSLog(@"%@",dataArray);
    
    shengArray=[NSMutableArray array];
    shiArray=[NSMutableArray array];
    xianArray=[NSMutableArray array];
    
    chooseDic=[NSMutableDictionary dictionary];
    
    //省数组
    shengArray=[addressModel mj_objectArrayWithKeyValuesArray:dataArray];
    //市数组，默认省数组第一个
    addressModel *model=shengArray[0];
    shiArray=[addressModel mj_objectArrayWithKeyValuesArray:model.son];
    
    //县数组，默认市数组第一个
    addressModel *model1=shiArray[0];
    xianArray=[addressModel mj_objectArrayWithKeyValuesArray:model1.son];
    addressModel *model2=xianArray[0];
    
    [chooseDic setValue:model.area_id forKey:@"sheng"];
    [chooseDic setValue:model.area_id forKey:@"shi"];
    [chooseDic setValue:model2.area_id forKey:@"xian"];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(5, 5, 40, 30);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneBtn.frame = CGRectMake(WIDTH - 5 - 40, 5, 40, 30);
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.doneBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
    [self addSubview:self.doneBtn];
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    [self addSubview:sepView];
    sepView.backgroundColor = NAV_SEP_COLOR;
    
    // 选择框
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.width, 220)];
    myPickerView.backgroundColor = TOOL_BACK_COLOR;
    // 显示选中框
    myPickerView.showsSelectionIndicator=YES;
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    [self addSubview:myPickerView];
}

- (void)doneAction {
    NSInteger p = [myPickerView selectedRowInComponent:0];
    NSInteger c = [myPickerView selectedRowInComponent:1];
    NSInteger a = [myPickerView selectedRowInComponent:2];
    
    addressModel *model= shengArray[p];
    NSString *sheng = model.area_district;
    
    addressModel *model1= shiArray[c];
    NSString *shi = model1.area_district;
    
    addressModel *model2= xianArray[a];
    NSString *qu = model2.area_district;
    
    if (self.addressBlock) {
        self.addressBlock([NSString stringWithFormat:@"%@%@%@",sheng,shi,qu]);
    }
    
}

- (void)remove {
    [self removeFromSuperview];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return shengArray.count;
    }
    if (component==1) {
        return  shiArray.count;
    }
    if (component==2) {
        return xianArray.count;
    }
    
    return 0;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"选中%ld列---%ld行",(long)component,(long)row);
    if (component==0) {
        addressModel *model=shengArray[row];
        shiArray=[addressModel mj_objectArrayWithKeyValuesArray:model.son];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        //默认第一个
        addressModel *model1=shiArray[0];
        xianArray=[addressModel mj_objectArrayWithKeyValuesArray:model1.son];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        addressModel *model2=xianArray[0];
        [chooseDic setValue:model.area_id forKey:@"sheng"];
        [chooseDic setValue:model1.area_id forKey:@"shi"];
        [chooseDic setValue:model2.area_id forKey:@"xian"];
    }
    if (component==1) {
        addressModel *model1=shiArray[row];
        xianArray=[addressModel mj_objectArrayWithKeyValuesArray:model1.son];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        addressModel *model2=xianArray[0];
        [chooseDic setValue:model1.area_id forKey:@"shi"];
        [chooseDic setValue:model2.area_id forKey:@"xian"];
    }
    if (component==2) {
        addressModel *model2=xianArray[row];
        [chooseDic setValue:model2.area_id forKey:@"xian"];
    }
    NSLog(@"%@",chooseDic);
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        addressModel *model=shengArray[row];
        return model.area_district;
    }
    if (component==1) {
        addressModel *model=shiArray[row];
        return model.area_district;
    }
    if (component==2) {
        addressModel *model=xianArray[row];
        return model.area_district;
    }
    return nil;
}


@end

//
//  WSImagePickerView.m
//  WSImagePicker
//
//  Created by Piter on 16/10/17.
//  Copyright © 2018年 wsjtwzs. All rights reserved.
//

#import "WSImagePickerView.h"
#import "WSPhotosBroseVC.h"
#import "JFImagePickerController.h"
#import "JTImagePickerCell.h"
#import "LoginModule.h"
#import "LoginController.h"

static NSString *imagePickerCellIdentifier = @"imagePickerCellIdentifier";

@interface WSImagePickerView()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WSImagePickerConfig *config;
@property (nonatomic, strong) NSMutableArray *wsimageModelArray;
@end


@implementation WSImagePickerView
@synthesize photosArray = _photosArray;

- (instancetype)initWithFrame:(CGRect)frame config:(WSImagePickerConfig *)config{
    if(self = [super initWithFrame:frame]) {
        _config = (config != nil)?config:([WSImagePickerConfig new]);
        [self setupView];
        [self initializeData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame config:nil];
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = _config.itemSize;
    layout.sectionInset = _config.sectionInset;
    layout.minimumLineSpacing = _config.minimumLineSpacing;
    layout.minimumInteritemSpacing = _config.minimumInteritemSpacing;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.clipsToBounds = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
    [_collectionView reloadData];
    
    [_collectionView registerClass:[JTImagePickerCell class] forCellWithReuseIdentifier:imagePickerCellIdentifier];
}

- (void)initializeData {
    _photosArray = [NSMutableArray new];
}

- (void)refreshCollectionView {
    NSInteger n;
    CGFloat width = _collectionView.frame.size.width - _config.sectionInset.left - _config.sectionInset.right;
    n = (width + _config.minimumInteritemSpacing)/(_config.itemSize.width + _config.minimumInteritemSpacing);
    CGFloat height = ((NSInteger)(_photosArray.count)/n +1) * (_config.itemSize.height + _config.minimumLineSpacing);
    height -= _config.minimumLineSpacing;
    height += _config.sectionInset.top;
    height += _config.sectionInset.bottom;
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    [_collectionView reloadData];
    if(self.viewHeightChanged) {
        self.viewHeightChanged(height);
    }
}

- (void)refreshImagePickerViewWithPhotoArray:(NSArray *)array {
    if(array.count > 0) {
        [_photosArray removeAllObjects];
        [_photosArray addObjectsFromArray:array];
    }
    [self refreshCollectionView];
}

- (NSArray<UIImage *> *)getPhotos {
    NSArray *array = [NSArray arrayWithArray:_photosArray];
    return array;
}

#pragma make - collectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_photosArray.count < _config.photosMaxCount) {
        return _photosArray.count + 1;
    }
    return _photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JTImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imagePickerCellIdentifier forIndexPath:indexPath];
    if(indexPath.row < _photosArray.count) {
        UIImage *image = _photosArray[indexPath.row];
        cell.imageView.image = image;
        cell.deleteBtn.tag = indexPath.row + 100;
        [cell.deleteBtn addTarget:self action:@selector(onClickDel:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBtn setHidden:NO];
    }
    else {
        cell.imageView.image = nil;
        cell.imageView.image = [UIImage imageNamed:@"bg_photo_add"];
        [cell.deleteBtn setHidden:YES];
    }
    return cell;
}

- (void)onClickDel:(UIButton *)sender {
    
    NSInteger clickIndex = sender.tag - 100;
    
    if (clickIndex < _photosArray.count) {
        [self.photosArray removeObjectAtIndex:clickIndex];
        [self.wsimageModelArray removeObjectAtIndex:clickIndex];
        [self deleteImage:clickIndex];
        [self.collectionView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *tmpArray = [NSMutableArray new];
    if (![LoginModule isLogged]) {
        LoginController *loginVc = [[LoginController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
        return;
    }
    if(indexPath.row < _photosArray.count) {

        __weak typeof(self) weakSelf = self;
        WSPhotosBroseVC *vc = [WSPhotosBroseVC new];
        vc.imageArray = self.wsimageModelArray;
        vc.showIndex = indexPath.row;
        vc.completion = ^ (NSArray *array){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_photosArray removeAllObjects];
                [_photosArray addObjectsFromArray:array];
                [weakSelf refreshCollectionView];
                
            });
        };
        vc.deleteBlock = ^(NSInteger sort) {
            [weakSelf deleteImage:sort];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self pickPhotos];
    }
}

- (void)deleteImage:(NSInteger)index {
    
    for (NSInteger i = 0; i < _wsimageModelArray.count; i ++) {
        WSImageModel *model = self.wsimageModelArray[i];
        model.sort = i;
    }
    self.deleteBtnBlock?self.deleteBtnBlock(index):nil;
}

- (void)pickPhotos{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选取",nil];
    [action showInView:self.navigationController.view];
}


#pragma mark - UIActionSheet delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *vc = [UIImagePickerController new];
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
            vc.delegate = self;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSInteger count = _config.photosMaxCount - _photosArray.count;
            [JFImagePickerController setMaxCount:count];
            JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
            picker.pickerDelegate = self;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - JFImagePicker Delegate - 因为这里上传图片是轮询接口，传图片这个地方要重新定义一个数组，保证每次选择的都是没上传过的图片（新选的），避免把刚传过的图片再传一遍。
- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    
    __weak typeof(self) weakself = self;
    NSInteger acount = picker.assets.count;
    NSInteger oldcount = _photosArray.count;
    __block int i = 0;
    
    if (oldcount > 0) {
        i  = oldcount;
    } else {
        [self.wsimageModelArray removeAllObjects];
    }
    __block NSMutableArray *WSImageModels = [NSMutableArray array];
    
    if (acount > 0) {
        [self.HUD showLoadingMessag:@"上传图片" toView:nil];
    }
    for (ALAsset *asset in picker.assets) {
        
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                WSImageModel *model = [WSImageModel new];
                model.image = image;
                model.sort = i;
                [WSImageModels addObject:model];
                [weakself.wsimageModelArray addObject:model];
                i ++;
                if (i == oldcount + acount) {
                    weakself.finishPickingBlock?weakself.finishPickingBlock(WSImageModels):nil;
                }
//                [_photosArray addObject:image];
//                [weakself refreshCollectionView];
                
            });
            
        }];
    }
    [self imagePickerDidCancel:picker];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}

#pragma  mark - imagePickerController Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self imageHandleWithpickerController:picker MdediaInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imageHandleWithpickerController:(UIImagePickerController *)picker MdediaInfo:(NSDictionary *)info {
    if (_photosArray.count == 0) {
        [self.wsimageModelArray removeAllObjects];
    }
    NSInteger count = self.wsimageModelArray.count;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    WSImageModel *model = [WSImageModel new];
    model.image = image;
    model.sort = count;
    [self.wsimageModelArray addObject:model];
    [self.HUD showLoadingMessag:@"上传图片" toView:nil];
    self.finishPickingBlock?self.finishPickingBlock(@[model]):nil;
//    [_photosArray addObject:image];
//    [self refreshCollectionView];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (NSMutableArray *)wsimageModelArray {
    if (!_wsimageModelArray) {
        _wsimageModelArray = [NSMutableArray array];
    }
    return _wsimageModelArray;
}


@end

@implementation WSImagePickerConfig

- (instancetype)init {
    if(self = [super init]) {
        _itemSize = CGSizeMake(60, 60);
        _sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _minimumLineSpacing = 10.0f;
        _minimumInteritemSpacing = 10.0f;
        _photosMaxCount = 9;
    }
    return self;
}


@end

//
//  PictureCollectViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/21.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "PictureCollectViewController.h"
#import "AddCollectionViewCell.h"
#import "PictureCollectionViewCell.h"
#import "TZImagePickerController.h"
#import "QNConfiguration.h"
#import <QiniuSDK.h>
#import "AppDelegate.h"

@interface PictureCollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>
{
    AddCollectionViewCell *addCell;
}
@property (nonatomic, strong)UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *mArrImageKey;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation PictureCollectViewController

- (void)dealloc {
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [NSMutableArray arrayWithArray:self.photos]; // 初始化 数组
    self.mArrImageKey = [NSMutableArray arrayWithArray:self.imageKeyArr];
    NSLog(@"self.dataSource：%@--%@",self.dataSource,self.self.mArrImageKey);
    
    [self reloadVCTitle];       // 设置 VC 的 title
    
    self.view.backgroundColor = GRAY_LIGHT;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ? YES:NO) {
        self.automaticallyAdjustsScrollViewInsets = NO; // 将坐标原点设置在（0，64）的位置
    }
    
    [self createView];
    
}

- (void)createView {
    
    [self.view addSubview:self.myCollectionView];   // 将 collectionView 添加到self.view 中
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;   // 获取appdelegate
    
    [appdelegate.window addSubview:self.progressView];      // 将进度条添加到 window 中
    
    UIButton *OKbutton = [UIButton buttonWithType:UIButtonTypeCustom];  // 创建一个确定按钮，位置：视图下方
    OKbutton.frame = CGRectMake(0, self.view.frame.size.height-64-44, Screen_Width, 44);
    OKbutton.backgroundColor = GREEN_1ab8;
    [OKbutton setTitle:@"确定" forState:0];
    [OKbutton setTitleColor:[UIColor whiteColor] forState:0];
    [OKbutton addTarget:self action:@selector(OKbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKbutton];
    UIWindow *window = [[UIWindow alloc] init];
    [window addSubview:self.progressView];
}

- (void)reloadVCTitle {
    
    int count = (int)self.dataSource.count;  // 计算传过来的图片array的个数
    
    [self setVCName:[NSString stringWithFormat:@"已选%d张照片",count] andShowSearchBar:NO andTintColor:BLACK_42 andBackBtnStr:nil];
}

- (void)setUploadQiniu:(BOOL)uploadQiniu {
    _uploadQiniu = uploadQiniu;
}

- (void)setPhotos:(NSArray<UIImage *> *)photos {
    
    _photos = photos;
    
    if (self.uploadQiniu) {
        
        [self pushPictureToQiniu:photos];   /// 将图片上传到七牛
    }
    
}

- (void) setLittleBtnPhotos:(NSArray<UIImage *> *)littleBtnPhotos {
    
    _littleBtnPhotos = littleBtnPhotos;
    
    [self pushPictureToQiniu:littleBtnPhotos];

}

- (void) setImageKeyArr:(NSMutableArray *)imageKeyArr {
    _imageKeyArr = imageKeyArr;
}

#pragma mark - 确定按钮
- (void) OKbuttonAction: (UIButton *)sender {
    
    if (self.dataSource.count < 1) {
        
        [MBProgressHUD showAutoMessage:@"请选择图片" ToView:nil];
        
        return;
    }
    
    self.photosArr(self.dataSource,self.mArrImageKey);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 删除图片
- (void) removeImageFromeDataSource: (UIButton *)sender {

    NSLog(@"%@",self.mArrImageKey[sender.tag]);
    
    [HTTPREQUEST_SINGLE deleteRequestWithService:[NSString stringWithFormat:@"images/%@",self.mArrImageKey[sender.tag]] andParameters:nil success:^(RequestManager *manager, NSDictionary *response) {

        NSLog(@"deleteImage:%@",response);
        
        [self.dataSource removeObjectAtIndex:sender.tag];
        
        [self.mArrImageKey removeObjectAtIndex:sender.tag];
        
        [self.myCollectionView reloadData];
        
        [self reloadVCTitle];               // 刷新 VC 的 title
        
        NSLog(@"mArrImageKey:%@,self.dataSource:%@",self.mArrImageKey,self.dataSource);
        
    } failure:^(RequestManager *manager, NSError *error) {
        
        [MBProgressHUD showError:error.debugDescription ToView:nil];
        
    }];
}
/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}
/**
 *  上传图片到七牛
 *
 *  @param photos 图片数组
 */
- (void)pushPictureToQiniu:(NSArray<UIImage *> *)photos{
    
    NSMutableArray *mArrImageName = [NSMutableArray array];
    
    for (int i = 0; i < photos.count; i++) {
        // 对图片的名称进行处理规则为 factory+"_"+UUID (UUID每次请求都是不同的)
        [mArrImageName addObject:[NSString stringWithFormat:@"factory_%@.jpg",[[NSUUID UUID] UUIDString]]];
    }
    
    [MBProgressHUD showAction:@"加载中..." ToView:nil];
    // 获取上传七牛的令牌
    [HTTPREQUEST_SINGLE requestWithServiceOfCollection:@"qiniutokens/1/" andParameters:nil requestType:0 isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"%@--%@",response,response[@"token"]);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);     // 1、获取一个全局串行队列
//
        dispatch_async(queue, ^{         // 2、把任务添加到队列中执行
        
            NSString *token = response[@"token"];  // response[@"uploadToken"][0];
            
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {  // 配置
                builder.zone = [QNZone zone1];      // 设置到 zone1
            }];
            
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            
            for (int i = 0; i < photos.count; i++) {
                
                NSData *data = [self compressOriginalImage:photos[i] toMaxDataSizeKBytes:100.0f];      // 压缩图片到 100K
                
                QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
                    NSLog(@"percent = %f",percent);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressView setProgress:percent animated:YES];
                        
                    });
                }];
                __block int count = 0;
                // 将数据上传到七牛
                [upManager putData:data key:mArrImageName[i] token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      NSLog(@"%d -- %@", i, info);
                      NSLog(@"%@", resp);
                      
                      @try {
                          if (resp == nil) {
                              
                              NSLog(@"%d--%d -- %@",i,count,self.dataSource);
                              if (count > 0) {
                                  
                                  [self.dataSource removeObjectAtIndex:i-count];
                              } else {
                                  
                                  [self.dataSource removeObjectAtIndex:i];
                              }
                              count ++;
                          } else {
                              if (self.littleBtnPhotos.count > 0) {
                                  [self.dataSource addObject:photos[i]];
                              }
                              
                              [self.mArrImageKey addObject:resp[@"key"]];
                          }
                          NSLog(@"imageKey:%@- dataSource:%@",self.mArrImageKey,self.dataSource);
                          
                          [self.myCollectionView reloadData];
                          
                          if (i+1 == photos.count) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  self.littleBtnPhotos = nil;
                              });
                          }
                          
                      } @catch (NSException *exception) {
                          NSLog(@"%@",exception);
                      } @finally {
                          
                      }
                              
                              
                  } option:uploadOption];
                
            }
            
        });
        
        [MBProgressHUD hideHUD];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"%@",error.debugDescription);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"似乎与网络已断开连接" ToView:nil];
    }];
}

#pragma mark - collecionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (Screen_Width - 2*(self.showImageCount+1)) / self.showImageCount;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 2, 0, 2);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0f;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@",self.dataSource);
    if (indexPath.item == self.dataSource.count) {
        
        addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCollectionViewCell" forIndexPath:indexPath];
        
        return addCell;
        
    } else {
        
        PictureCollectionViewCell *pictureCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCollectionViewCell" forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            
            pictureCell.coverView.hidden = NO;
            pictureCell.coverLabel.hidden = NO;
            
        } else {    // 隐藏封面
            
            pictureCell.coverView.hidden = YES;
            pictureCell.coverLabel.hidden = YES;
            
        }
        
        pictureCell.imageView.image = self.dataSource[indexPath.item];
        
        [pictureCell.closeButton addTarget:self action:@selector(removeImageFromeDataSource:) forControlEvents:UIControlEventTouchUpInside];
        
        pictureCell.closeButton.tag = indexPath.item;
        
        return pictureCell;
    }
    
}
#pragma mark - collectionView delegate 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.dataSource.count) {  // 点击 ➕号的响应事件
        
        int shounldSelectImageCount = 9 - (int)self.dataSource.count;   // 判断应该选择几张图片
        
        if (shounldSelectImageCount <= 0) {    // 当应当选择的图片数量小于零时，则不能进行图片选择
            // 弹出提示框
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"最多只能选择9张图片" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        // 进行图片选择
        TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:shounldSelectImageCount columnNumber:3 delegate:self pushPhotoPickerVc:YES];
        
        imagePickerVC.sortAscendingByModificationDate = NO;
        
        __weak typeof(self) weakSelf = self;
        // 选中图片的回调
        [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            [self pushPictureToQiniu:photos];       // 将选中的图片上传至7牛
            
            for (UIImage *obj in photos) {
                
                [weakSelf.dataSource addObject: obj];
                
            }
            
            [self.myCollectionView reloadData]; // 添加到数组中
            
            [self reloadVCTitle];               // 刷新 VC 的 title
            
        }];
        
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    
}
// 移动图片
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == self.dataSource.count) {
        return NO;  // 点击添加的item 不允许移动
    }
    
    //返回YES允许其item移动
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
    if (destinationIndexPath.item == self.dataSource.count) {
        return;
    }
    
    // 取出源item数据
    id objc = [self.dataSource objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataSource removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataSource insertObject:objc atIndex:destinationIndexPath.item];
    
    id key = [self.imageKeyArr objectAtIndex:sourceIndexPath.item];
    [self.imageKeyArr removeObject:key];
    [self.imageKeyArr insertObject:key atIndex:destinationIndexPath.item];
    
    PictureCollectionViewCell *pictureCell = (PictureCollectionViewCell*)[collectionView cellForItemAtIndexPath:sourceIndexPath];
    
    pictureCell.coverView.hidden = YES;
    pictureCell.coverLabel.hidden = YES;
    
    PictureCollectionViewCell *pictureCell1 = (PictureCollectionViewCell*)[collectionView cellForItemAtIndexPath:destinationIndexPath];
    
    pictureCell1.coverView.hidden = YES;
    pictureCell1.coverLabel.hidden = YES;
    
    [self.myCollectionView reloadData];
    
}

- (void)handleLongGesture: (UILongPressGestureRecognizer *)sender {

    switch (sender.state) { // 判断手势状态
        case UIGestureRecognizerStateBegan:
        {
            // 判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.myCollectionView indexPathForItemAtPoint:[sender locationInView:self.myCollectionView]];
            if (indexPath == nil) {
                break;
            }
            // 在路径上则开始移动该路径上的cell
            [self.myCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSIndexPath *AddIndexPath = [self.myCollectionView indexPathForCell:addCell];
            NSIndexPath *indexPath = [self.myCollectionView indexPathForItemAtPoint:[sender locationInView:self.myCollectionView]];
            if (indexPath == AddIndexPath) {
                   break ;
            }
            // 移动过程当中随时更新cell位置
            [self.myCollectionView updateInteractiveMovementTargetPosition:[sender locationInView:self.myCollectionView]];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            // 移动结束后关闭cell移动
            [self.myCollectionView endInteractiveMovement];
            
        }
            break;
            
        default:
            [self.myCollectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - lazyload
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64-44) collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = GRAY_LIGHT;
        
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"PictureCollectionViewCell"];
        
        [_myCollectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"AddCollectionViewCell"];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
        
        [_myCollectionView addGestureRecognizer:longGesture];
    }
    
    return _myCollectionView;
}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];  // 设置 进度条 style 为普通进度条
        
        _progressView.frame = CGRectMake(0, 0, Screen_Width, 20);   // 设置 进度条 位置
        
        _progressView.backgroundColor = [UIColor whiteColor];       // 设置 进度条 背景色
        
        _progressView.progressTintColor = GREEN_19b8;               // 设置 进度条 走过的颜色为绿色
        
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 20.0f);  // 设置 进度条 高度 为 20像素
        
        _progressView.hidden = YES;                                 // 设置 进度条 隐藏
    }
    
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

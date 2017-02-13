//
//  BrokerDetailViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BrokerDetailViewController.h"

#import "FootCollectionReusableView.h"
#import "PublisherCollectionViewCell.h"
#import "DetailPictureCollectionViewCell.h"
#import "DetailMapCollectionViewCell.h"
#import "DetailFactoryIntroduceCollectionViewCell.h"
#import "DetailHeadCollectionReusableView.h"
#import "DetailOfFactoryInfoCollectionViewCell.h"

#import "PublishManViewController.h"
#import "ReportViewController.h"
#import "NSString+Judge.h"
#import "FOLUserInforModel.h"
#import "GeoCodeOfBaiduMap.h"

@interface BrokerDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL isLike;
    
    DetailPictureCollectionViewCell *pictureCell;
    
    DetailFactoryIntroduceCollectionViewCell *introduceCell;
    
    BOOL showSeeAll;
    
    CGFloat introduceHeight; // 厂房介绍的文字高度
    
    CGFloat allHeight;      // 文本的总高度
    
    CGFloat lineHeight;     // 一行文本的高度
    
//    RequestMessage *requestMessage; // 请求接口
    CGFloat titleHeight;    // 标题的高度
}
@property (weak, nonatomic) IBOutlet UIImageView *brokerHeaderImageView;    // 头像

@property (weak, nonatomic) IBOutlet UIView *imageViewBGView;          // 头像背后的View

@property (weak, nonatomic) IBOutlet UILabel *linkerNameLabel;          // 联系人名称

@property (weak, nonatomic) IBOutlet UILabel *linkerTelLabel;           // 联系人手机号码

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic, strong) UIImage *mapImage;
@end

@implementation BrokerDetailViewController


- (void)dealloc {
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setVCName:@"厂房详情" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:nil];
    
    [self.rightImageItemButton setTintColor:[UIColor clearColor]];
    
    [self loadViewType];
    
    [self registerCollectionView];
}
#pragma mark - 发送短信
- (IBAction)msmButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.brokerInfoDic[@"phone_num"]]]];
}
#pragma mark - 打电话
- (IBAction)phoneButtonAction:(UIButton *)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.brokerInfoDic[@"phone_num"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"10086"]]];
    
}

- (void)loadViewType {
    
    [self loadViewOfCollection:isLike];
    
    self.linkerNameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.linkerNameLabel.font.pointSize]];
    self.linkerTelLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.linkerTelLabel.font.pointSize]];
    
    self.linkerNameLabel.text = self.brokerInfoDic[@"real_name"];
    self.linkerTelLabel.text = self.brokerInfoDic[@"phone_num"];
    self.imageViewBGView.layer.borderColor = GRAY_cc.CGColor;
    self.imageViewBGView.layer.borderWidth = 0.5;
    self.imageViewBGView.layer.cornerRadius = 25;
    self.imageViewBGView.layer.masksToBounds = YES;
    
    self.brokerHeaderImageView.layer.cornerRadius = 48/2;
    self.brokerHeaderImageView.layer.masksToBounds = YES;
    
}

- (void) registerCollectionView {
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    self.myCollectionView.backgroundColor = GRAY_LIGHT;
    // 注册 cell
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    // 地图的cell
    [self.myCollectionView registerClass:[DetailMapCollectionViewCell class] forCellWithReuseIdentifier:@"DetailMapCollectionViewCell"];
    // 厂房简介 cell
    [self.myCollectionView registerClass:[DetailFactoryIntroduceCollectionViewCell class] forCellWithReuseIdentifier:@"DetailFactoryIntroduceCollectionViewCell"];
    // 厂房信息 cell
    [self.myCollectionView registerClass:[DetailOfFactoryInfoCollectionViewCell class] forCellWithReuseIdentifier:@"DetailOfFactoryInfoCollectionViewCell"];
    // 图片轮播 的cell
    [self.myCollectionView registerClass:[DetailPictureCollectionViewCell class] forCellWithReuseIdentifier:@"DetailPictureCollectionViewCell"];
    // 头部 的view
    [self.myCollectionView registerClass:[DetailHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DetailHeadCollectionReusableView"];
    // foot 灰色
    [self.myCollectionView registerClass:[FootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootCollectionReusableView"];
  
}

/**
 *  navigation 添加 两个 右边按钮的点击回调事件
 */
- (void)rightActionSecond:(UIButton *)sender {
    
    if (sender.tag == 0) {
        // 先判断用户是否登录
        if (![self judgeUserLogin]) {
            return;
        }
        
        isLike = !isLike;
        if (isLike) {
            
            [self loadViewOfCollection:isLike];
        
            [self collectionBrokerRequestWithID:(int)self.model.factoryModel.id andRequestType:1];
            
            [UIView animateWithDuration:0.5f animations:^{
                
                pictureCell.likeBtn.frame = CGRectMake(Screen_Width-16*2-pictureCell.imagePlayerView.frame.size.height*33/120, 10, pictureCell.imagePlayerView.frame.size.height*33/240, pictureCell.imagePlayerView.frame.size.height*33/240);     // 做上升 动画
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5f animations:^{  // 做旋转动画
                    //                pictureCell.likeBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
                    CABasicAnimation* rotationAnimation;
                    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
                    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI ];
                    rotationAnimation.duration = 0.5;
                    rotationAnimation.cumulative = YES;
                    rotationAnimation.repeatCount = 1;
                    
                    [pictureCell.likeBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.5f animations:^{  // 做下降动画
                        
                        pictureCell.likeBtn.frame = CGRectMake(Screen_Width-16*2-pictureCell.imagePlayerView.frame.size.height*33/120, 32, pictureCell.imagePlayerView.frame.size.height*33/240, pictureCell.imagePlayerView.frame.size.height*33/240);     // 做上升 动画
                        
                    }];
                }];
            }];
            
        } else {
            [self loadViewOfCollection:isLike];
            [self collectionBrokerRequestWithID:self.model.factoryModel.id andRequestType:2];
        }
    } else {    // 分享
        NSLog(@"分享");
    }
}

#pragma mark - 更新收藏按钮
- (void)loadViewOfCollection:(BOOL)like {
    
    if (like) { // 收藏
        //        [self addRightItemWithLogo:[UIImage imageNamed:@"detail_like"] andItemTintColor:RED_df3d]; // 设置导航栏 为收藏状态
        
        [self addRightImageItem:@[@"detail_like",@"share"] buttonCount:2];
        
        [pictureCell.likeBtn setImage:[UIImage imageNamed:@"detail_like"] forState:UIControlStateNormal];  // 设置pictureCell 的收藏按钮为收藏状态
        isLike = YES;
        
    } else {    // 没收藏
        //        [self addRightItemWithLogo:[UIImage imageNamed:@"detail_unlike_white"] andItemTintColor:BLACK_1a];
        [self addRightImageItem:@[@"detail_unlike",@"share"] buttonCount:2];
        
        [pictureCell.likeBtn setImage:[UIImage imageNamed:@"detail_unlike_white"] forState:UIControlStateNormal];    // 设置pictureCell 的收藏按钮为 未收藏状态
        isLike = NO;
    }
    
}

// 通过model 更新界面
- (void)setModel:(BrokerFactoryInfoModel *)model {
    
    _model = model;
    
    titleHeight = [NSString getHeightOfAttributeRectWithStr:model.factoryModel.title andSize:CGSizeMake(Screen_Width-12, 66) andFontSize:[UIFont adjustFontSize:16] andLineSpace:0];    // 计算title 的文字高度
    
    [self.myCollectionView reloadData];
    
    // 先判断用户是否登录
    if ([self judgeUserLogin]) {
        [self collectionBrokerRequestWithID:model.factoryModel.id andRequestType:0]; // 请求接口，判断 改信息是否被收藏
    }
    
    __weak BrokerDetailViewController *weakSelf = self;
    
//   http://api.map.baidu.com/staticimage?width=400&height=200&markers=水蛇涌幼儿园附近&zoom=18

    GeoCodeOfBaiduMap *baiduMap = [GeoCodeOfBaiduMap new];
    
    [baiduMap getBaiduStaticimageWithAddress:[NSString stringWithFormat:@"%@%@",_model.factoryModel.area,_model.factoryModel.address]];
    
    baiduMap.imageBlock = ^(UIImage *image){
        weakSelf.mapImage = image;
    };
}

#pragma mark - 返回按钮
- (void)leftItemButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - pictureCell likeBtn 的点击事件
- (void)likeBtnAction:(UIButton *)sender {
    [self rightItemButtonAction];
}

/**
 *  请求 收藏接口 收藏 取消收藏，查看收藏状态 经纪人发布的
 *
 *  @param factoryID  厂房id
 *  @param type       请求方式  0：get 1:post 2:delete
 
 */
- (void)collectionBrokerRequestWithID:(int)factoryID andRequestType:(int)type {
    
    NSString *url = [NSString stringWithFormat:@"promediummessages/%d/collection/",factoryID];
    
    [HTTPREQUEST_SINGLE requestWithServiceOfCollection:url andParameters:nil requestType:type isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"收藏接口的请求：%@",response[@"erro_msg"]);
        
        if (type == 0) {
            BOOL flag = [response[@"isCollect"] boolValue];
            [self loadViewOfCollection:flag];
//            isLike = YES;
        }
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"error:%@",error.debugDescription);
    }];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;   // 获取偏移 Y 值
    
    if (scrollView.contentOffset.y > 50) {
        
        self.navigationController.navigationBarHidden = NO;
        // 计算 透明度的变化
        CGFloat alpha = MIN(1, 1 - ((64 + 64 - offsetY) / 64));
        
        self.navigationController.navigationBar.alpha = alpha;
        
    } else {
        
        self.navigationController.navigationBarHidden = YES;
    }
    
}

#pragma mark - collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;

}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return CGSizeZero;
    }
    return CGSizeMake(Screen_Width, 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            break;
        case 1:case 2:case 3:
        {
            return CGSizeMake(Screen_Width, Screen_Height*37/568);
        }
        default:
            break;
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        FootCollectionReusableView * footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootCollectionReusableView" forIndexPath:indexPath];
        return footView;
        
    } else {
        
        DetailHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DetailHeadCollectionReusableView" forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 1:
            {
                headView.headLabel.text = @"厂房信息";
            }
                break;
            case 2:
            {
                headView.headLabel.text = @"厂房介绍";
            }
                break;
            case 3:
            {
                headView.headLabel.text = @"厂房位置";
            }
                break;
            default:
                break;
        }
        return headView;
    }
    return reusableView;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *string = self.model.factoryModel.description_pro;
    NSNumber * lineCount;          // 文本的行数
    switch (indexPath.section) {
        case 0: // picture
        {
            CGFloat height = Screen_Width*3/4 + 66 + 24 + titleHeight;
            return CGSizeMake(Screen_Width, height);
        }
         
            break;
        case 1: // infomation
            return CGSizeMake(Screen_Width, Screen_Height*45/284);
            break;
        case 2: // introduce
            
            allHeight = [NSString getHeightOfAttributeRectWithStr:string andSize:CGSizeMake(Screen_Width-30, MAXFLOAT) andFontSize:[UIFont adjustFontSize:14.0f] andLineSpace:5.0f];
            
            lineHeight = [NSString getHeightOfAttributeRectWithStr:@"求单行文本的高度" andSize:CGSizeMake(Screen_Width-30, MAXFLOAT) andFontSize:[UIFont adjustFontSize:14.0f] andLineSpace:5.0f];
            
            lineCount = @(allHeight/lineHeight);
            
            if ([lineCount floatValue] > 3.0) {
                
                showSeeAll = YES;
                
                if (!introduceCell.seeAllButton.selected) {
                    
                    introduceHeight = lineHeight*3;
                    
                } else {
                    
                    introduceHeight = allHeight + lineHeight;
                }
                
                return CGSizeMake(Screen_Width, 60+introduceHeight);
            } else {
                showSeeAll = NO;
                
                introduceHeight = allHeight;    // 减去button 的高度
                
                return CGSizeMake(Screen_Width, 30+introduceHeight);
            }
            
            break;
        case 3: // map
            return CGSizeMake(Screen_Width, Screen_Height*183/568);
            break;
        default:
            break;
    }
    
    return CGSizeZero;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            return [self imagePlayerCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case 1:
        {
            return [self infoCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case 2:
        {
            return [self introduceCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case 3:
        {
            return [self mapCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    
    return cell;
}
// 图片轮播
- (UICollectionViewCell *)imagePlayerCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    pictureCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailPictureCollectionViewCell" forIndexPath:indexPath];
    [pictureCell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pictureCell.backBtn addTarget:self action:@selector(leftItemButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    pictureCell.brokerFactoryModel = self.model.factoryModel;
    
    return pictureCell;
}
// 信息
- (UICollectionViewCell *)infoCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailOfFactoryInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailOfFactoryInfoCollectionViewCell" forIndexPath:indexPath];
    cell.dataDic = @{@"created_time":self.model.created_time,
                     @"rent_type":self.model.factoryModel.rent_type,
                     @"pre_pay":self.model.factoryModel.pre_pay,
                     @"view_count":@(self.model.view_count),
                     @"factory_id":@(self.model.factoryModel.id)};
    return cell;
    
}
// 介绍
- (UICollectionViewCell *)introduceCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    introduceCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailFactoryIntroduceCollectionViewCell" forIndexPath:indexPath];
    
    NSString *string = self.model.factoryModel.description_pro;
    
    if (!showSeeAll) {
        
        introduceCell.seeAllButton.hidden = YES;
        introduceCell.labelConstraintHeight.constant = 15;
    }
    
    [introduceCell.seeAllButton addTarget:self action:@selector(seeAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    introduceCell.intruduceLabel.attributedText = [NSString attributedString:string andTextWidth:Screen_Width-30 andLineSpace:5.0f];
    
    return introduceCell;
    
}
// 地图
- (UICollectionViewCell *)mapCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailMapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailMapCollectionViewCell" forIndexPath:indexPath];
    
    cell.mapImageView.image = self.mapImage;
    
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",_model.factoryModel.area,_model.factoryModel.address];
    
    return cell;
    
}

#pragma mark - 查看全部
- (void)seeAllButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [introduceCell.seeAllButton setTitle:@"收起" forState:0];
    } else {
        [introduceCell.seeAllButton setTitle:@"查看全部" forState:0];
    }
    
    [self.myCollectionView reloadData];
}
#pragma mark - 判断用户是否登录
- (BOOL)judgeUserLogin {
    
    NSMutableArray *array = [FOLUserInforModel findAll];
    if (array.count <= 0) {
        [MBProgressHUD showAutoMessage:@"尚未登录，请登录哦~" ToView:nil];
        return NO;
    }
    return YES;
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

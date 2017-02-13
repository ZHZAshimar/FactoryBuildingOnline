//
//  FactoryDetailViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "FactoryDetailViewController.h"

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
#import "RequestMessage.h"
#import "FOLUserInforModel.h"
#import "GeoCodeOfBaiduMap.h"
#import "SecurityUtil.h"
#import "ZHZShareView.h"    // 分享界面

@interface FactoryDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PublisherCollectionViewCellDelegate>
{
    BOOL isLike;
    DetailPictureCollectionViewCell *pictureCell;
    
    DetailFactoryIntroduceCollectionViewCell *introduceCell;
    
    BOOL showSeeAll;
    
    CGFloat introduceHeight; // 厂房介绍的文字高度
    
    CGFloat allHeight;      // 文本的总高度
    
    CGFloat lineHeight;     // 一行文本的高度
    
    RequestMessage *requestMessage; // 请求接口
    
    CGFloat titleHeight;    // 标题label的高度
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *linkManLabel; // 联系人
@property (weak, nonatomic) IBOutlet UILabel *linkManTelLabel;  // 联系人电话
@property (weak, nonatomic) IBOutlet UIView *linkManBGView;
@property (weak, nonatomic) IBOutlet UIImageView *linkManImageView;
@property (nonatomic, strong) UIImage *mapImage;
@property (nonatomic, strong) NSDictionary *contanterDic;
@end

@implementation FactoryDetailViewController

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
    
    [self.rdv_tabBarController setTabBarHidden:YES];    // 隐藏底部导航
    self.navigationController.navigationBarHidden = YES;    // 隐藏导航栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置导航栏
    [self setVCName:@"厂房详情" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:nil];
    // 设置导航栏的返回按钮的图片
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];

    [self loadViewType];    // 加载界面
    
    [self getPublishInfo];
    
    [self postFactoryHistory];
    
}

- (void)loadViewType {
    
    [self loadViewOfCollection:isLike];
    // 设置 联系人的 名称和手机号码的label 文字自适应
    self.linkManLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.linkManLabel.font.pointSize]];
    self.linkManTelLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.linkManTelLabel.font.pointSize]];
    
    self.linkManLabel.text = self.model.ctModel.name;
    self.linkManTelLabel.text = self.model.ctModel.phone_num;
    self.linkManBGView.layer.borderColor = GRAY_cc.CGColor;
    self.linkManBGView.layer.borderWidth = 0.5;
    self.linkManBGView.layer.cornerRadius = 25;
    self.linkManBGView.layer.masksToBounds = YES;
    
    self.linkManImageView.layer.cornerRadius = 22;
    self.linkManImageView.layer.masksToBounds = YES;
    
    [self registerCollectionView];  // 注册 collectionView 的 cell
}
// 设置collectionView
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
    
    [self.myCollectionView registerClass:[PublisherCollectionViewCell class] forCellWithReuseIdentifier:@"PublisherCollectionViewCell"];    // 注册发布人的cellView
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
            
            [requestMessage collectionRequestWithID:(int)self.model.id andRequestType:1];
            
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
                        
                        pictureCell.likeBtn.frame = CGRectMake(Screen_Width-16*2-pictureCell.imagePlayerView.frame.size.height*33/120, 32, pictureCell.imagePlayerView.frame.size.height*33/240, pictureCell.imagePlayerView.frame.size.height*33/240);
                        
                    }];
                }];
            }];
            
        } else {
            [self loadViewOfCollection:isLike];
            [requestMessage collectionRequestWithID:self.model.id andRequestType:2];
        }
    } else {    // 分享
        [self share];
    }
    
}
#pragma mark - 更新收藏按钮
- (void)loadViewOfCollection:(BOOL)like {
    
    if (like) { // 收藏
//        [self addRightItemWithLogo:[UIImage imageNamed:@"detail_like"] andItemTintColor:RED_df3d]; // 设置导航栏 为收藏状态
        
        [self addRightImageItem:@[@"detail_like",@"detail_share"] buttonCount:2];

        [pictureCell.likeBtn setImage:[UIImage imageNamed:@"detail_like"] forState:UIControlStateNormal];  // 设置pictureCell 的收藏按钮为收藏状态
        isLike = YES;
        
    } else {    // 没收藏

        [self addRightImageItem:@[@"detail_unlike",@"detail_share"] buttonCount:2];
        
        [pictureCell.likeBtn setImage:[UIImage imageNamed:@"detail_unlike_white"] forState:UIControlStateNormal];    // 设置pictureCell 的收藏按钮为 未收藏状态
        isLike = NO;
    }
    
}
// 记录浏览事件
- (void)postFactoryHistory {
    
    NSString *url = [NSString stringWithFormat:@"wantedmessages/%d/view/",self.model.id];
    
    if ([self judgeUserLogin]) {
        
        [HTTPREQUEST_SINGLE postRequestWithService:url andParameters:nil isShowActivity:NO dicIsEncode:NO success:^(RequestManager *manager, NSDictionary *response) {
            NSLog(@"统计浏览历史--登录 ：%@",response);
        } failure:^(RequestManager *manager, NSError *error) {
            NSLog(@"统计浏览历史--登录 ：%@",error.debugDescription);
        }];
    } else {
        [HTTPREQUEST_SINGLE postRequestWithURL:url andParameters:nil andShowAction:NO success:^(RequestManager *manager, NSDictionary *response) {
            NSLog(@"统计浏览历史-- 未登录 ：%@",response);
        } failure:^(RequestManager *manager, NSError *error) {
            NSLog(@"统计浏览历史-- 未登录 ：%@",error.debugDescription);
        }];
    }
}

#pragma mark - 获取发布人详情
- (void)getPublishInfo {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_POST_REGISTER,[NSString stringWithFormat:@"%d",self.model.owner_id]];
    
    __weak typeof(self) weakSelf = self;
    
    [HTTPREQUEST_SINGLE getRequestWithService:url andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog( @"%@",response);
        
        weakSelf.contanterDic = response[@"userPublic"];
        
        [weakSelf.myCollectionView reloadData];
        
    } failure:^(RequestManager *manager, NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}

#pragma mark - 通过model 更新界面
- (void)setModel:(WantedMessageModel *)model {
    
    _model = model;
    
    titleHeight = [NSString getHeightOfAttributeRectWithStr:model.ftModel.title andSize:CGSizeMake(Screen_Width-24, 20) andFontSize:[UIFont adjustFontSize:16] andLineSpace:0];     // 计算标题的高度
    
    [self.myCollectionView reloadData];
    
    requestMessage = [RequestMessage new];
    // 先判断用户是否登录
    if ([self judgeUserLogin]) {
        [requestMessage collectionRequestWithID:model.id andRequestType:0]; // 请求接口，判断 改信息是否被收藏
    }
    
    __weak FactoryDetailViewController *weakSelf = self;

    requestMessage.datablock = ^(NSDictionary *dic){    // 更新收藏按钮
        
        isLike = YES;
        
        int flag = [dic[@"isCollect"] intValue];
        
        [weakSelf loadViewOfCollection:flag];

    };
    
    NSArray *areaArray = [NSString arrayWithJsonString:model.ftModel.geohash];  // 字符串转数组
    NSLog(@"反 geohash----%@",areaArray);
    GeoCodeOfBaiduMap *baiduMap = [GeoCodeOfBaiduMap new];
    [baiduMap getBaiduStaticimageWithArray:areaArray];  /* 通过经纬度，获取百度地图 静态图片 */
    baiduMap.imageBlock = ^(UIImage *image){    /// block 返回图片
        weakSelf.mapImage = image;
    };
}

#pragma mark - 返回按钮
- (void)leftItemButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - pictureCell likeBtn 的点击事件
- (void)likeBtnAction:(UIButton *)sender {
    [self rightActionSecond:sender];
}
#pragma mark - 分享
- (void)shareBtnAction:(UIButton *)sender {
    [self share];
}

- (void)share{
    ZHZShareView *shareView = [[ZHZShareView alloc] init];
    [shareView show];
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

#pragma mark - push publishDetail

#pragma mark - 调用电话
- (IBAction)callLinkManAction:(id)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.ctModel.phone_num];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"10086"]]];
    
}
#pragma mark - 调用短信
- (IBAction)messageLinkManAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.model.ctModel.phone_num]]];
}

#pragma mark - collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 5;
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
// 头部高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:case 4:
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
// 每个cell 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *string = self.model.ftModel.description_factory;
    NSNumber * lineCount;          // 文本的行数
    switch (indexPath.section) {
        case 0: // picture
        {
            CGFloat height = Screen_Width*3/4+66+24+titleHeight;
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
                
            } else {
                showSeeAll = NO;
                
                introduceHeight = allHeight;    // 只显示文字的高度 ，不显示button 的高度
            }
            
            return CGSizeMake(Screen_Width, 30+introduceHeight);
            break;
        case 3: // map
            return CGSizeMake(Screen_Width, Screen_Height*183/568);
            break;
        case 4: // publisher
            return CGSizeMake(Screen_Width, Screen_Height*14/71);
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
        case 4:
        {
            return [self publisherCollectionView:collectionView cellForItemAtIndexPath:indexPath];
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
    [pictureCell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside]; // 收藏
    [pictureCell.backBtn addTarget:self action:@selector(leftItemButtonAction) forControlEvents:UIControlEventTouchUpInside];   // 返回
    [pictureCell.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];      // 分享
    
    NSLog(@"%@",self.model);
    pictureCell.ftModel = self.model.ftModel;
    
    return pictureCell;
}
// 信息
- (UICollectionViewCell *)infoCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailOfFactoryInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailOfFactoryInfoCollectionViewCell" forIndexPath:indexPath];
    cell.dataDic = @{@"created_time":self.model.created_time,
                    @"rent_type":self.model.ftModel.rent_type,
                     @"pre_pay":self.model.ftModel.pre_pay,
                     @"view_count":@(self.model.view_count),
                     @"factory_id":@(self.model.ftModel.id)};
    return cell;
    
}
// 介绍
- (UICollectionViewCell *)introduceCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    introduceCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailFactoryIntroduceCollectionViewCell" forIndexPath:indexPath];

   NSString *string = self.model.ftModel.description_factory;
    
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
    
    cell.addressLabel.text = self.model.ftModel.address_overview;
    
    return cell;
    
}
// 发布人
- (UICollectionViewCell *)publisherCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PublisherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublisherCollectionViewCell" forIndexPath:indexPath];
    cell.dataDic = self.contanterDic;
    cell.publishDelegate = self;
    
//    cell.publisherHeadImageView.image = [UIImage imageNamed:@"11.png"];
//    [cell.publishDetailBtn addTarget:self action:@selector(publishDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
#pragma mark - PublisherCollectionViewCellDelegate -
// 发布人发送短信
- (void)sendMessage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.contanterDic[@"phone_num"]]]];
}
// 发布人打电话
- (void)callPhone {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contanterDic[@"phone_num"]]]];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.contanterDic[@"phone_num"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
// 跳转发布人界面
- (void)pushPublisherVC {
    
    PublishManViewController *publishManVC = [[PublishManViewController alloc] init];
    
    publishManVC.contanterDic = self.contanterDic;
    
    [self.navigationController pushViewController:publishManVC animated:YES];
    
}
// 跳转举报界面
- (void)pushResportVC {
    
    ReportViewController *reportVC = [ReportViewController new];
    reportVC.model = self.model;
    [self.navigationController pushViewController:reportVC animated:YES];
}

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

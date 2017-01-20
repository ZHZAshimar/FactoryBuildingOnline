//
//  HomeHorizontalScrollView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/29.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeHorizontalScrollView.h"
#import "HMSegmentedControl.h"
#import "HomeHorizontalCellView.h"
#import "HorizonalCollectionViewCell.h"
#import <MJRefresh.h>
#import "HomeRequest.h"

@interface HomeHorizontalScrollView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    NSArray *segmentImageArr;   // 背景图片
    int manCount;
    BOOL rightMost;
    HomeRequest *request;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *segmentedImageView;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) NSMutableArray *brokersArray; // 经纪人数组
@property (nonatomic, strong) NSString *nextURL;            // next url
@property (nonatomic, strong) UICollectionView *myCollectionView;
@end

@implementation HomeHorizontalScrollView

- (id)initWithFrame:(CGRect)frame index:(NSUInteger)index{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.indexSegment = index;  // 记录点中的分段控件的
        self.nextURL = @"";
        rightMost = NO;
        manCount = 6;
        self.brokersArray = [NSMutableArray array];
        
        segmentImageArr = @[[UIImage imageNamed:@"segment_1.png"],[UIImage imageNamed:@"segment_2"],[UIImage imageNamed:@"segment_3"]];
        
        [self addSubview:self.bgView];
        
        request = [HomeRequest new];    // 初始化网络请求类
        
        __weak typeof (self) weakSelf = self;
        
        request.promediusBlock = ^(NSDictionary *response) {
//            NSLog(@"response:%@--%@",response,weakSelf.brokersArray);
            
            weakSelf.nextURL = response[@"next"];
            
            NSArray *tmpArr = response[@"proMedium"];
            
            for (id dic in tmpArr) {
                [weakSelf.brokersArray addObject:dic];
            }
            
            [weakSelf.myCollectionView reloadData];
            
            rightMost = NO;
        };

        
    }
    return self;
}

- (void)setIndexSegment:(NSInteger)indexSegment {
    _indexSegment = indexSegment;
}

- (void) setBrokerDic:(NSDictionary *)brokerDic {
    
    _brokerDic = brokerDic;
    
    if (brokerDic.count>0) {
        NSArray *tmpArr = brokerDic[@"proMedium"];
        
        for (NSDictionary *dic in tmpArr) {
            [self.brokersArray addObject:dic];
        }
        self.nextURL = brokerDic[@"next"];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//        NSLog(@"x = %f",self.myCollectionView.contentOffset.x);
//        NSLog(@"y = %f",self.myCollectionView.contentOffset.y);
    // 判断 scrollView 滚动的x
    if (self.myScrollView.contentOffset.x >= Screen_Width * 0.5 && self.myScrollView.contentOffset.x < Screen_Width * 1.5) {    // 显示我是业主
        
        [self.segmentedControl setSelectedSegmentIndex:1];
        self.indexSegment = 1;
    } else if (self.myScrollView.contentOffset.x >= Screen_Width * 1.5) {   // 显示 经纪人
        
        [self.segmentedControl setSelectedSegmentIndex:2];
        self.indexSegment = 2;
    } else {                                                        // 显示 我要找房
        
        [self.segmentedControl setSelectedSegmentIndex:0];
        self.indexSegment = 0;
    }
    
    self.segmentedImageView.frame = CGRectMake(self.indexSegment * self.frame.size.width/3, 0, self.frame.size.width/3, 40);    // 重绘 segmented 背后的imageView 的 frame 的位置
    switch (self.indexSegment) {    //
        case 0:
            self.segmentedImageView.image = [UIImage imageNamed:@"segment_1.png"];
            break;
        case 1:
            self.segmentedImageView.image = [UIImage imageNamed:@"segment_2.png"];
            break;
        case 2:
            self.segmentedImageView.image = [UIImage imageNamed:@"segment_3.png"];
            break;
        default:
            break;
    }
    
    // 此通知用于记录之前点击的item
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INDEXCHANGE" object:self userInfo:@{@"index":[NSString stringWithFormat:@"%ld",self.indexSegment]}];
    if (self.segmentedControl.selectedSegmentIndex == 2) {
        // 判断collectionView 是否滑到底端，控件的宽度 + 偏移的X的位置 >= 控件的滚动宽度
        CGFloat width = self.myCollectionView.frame.size.width;
        
        CGFloat contentOffSetX = self.myCollectionView.contentOffset.x;
        
        CGFloat contentWidth = self.myCollectionView.contentSize.width;
        
        if (width + contentOffSetX >= contentWidth) {
            
            NSLog(@"%@",self.nextURL);
            
            if (![self.nextURL isEqual:[NSNull null]] && !rightMost) {  // 滚动到最右端
                NSLog(@"end");
                
                rightMost = YES;
                
                [request getNextPromediumsWithURL:self.nextURL];    // nextUrl 请求

                return;
            }
        }
    }
    
}

- (void)tapButtonAction: (UIButton *)sender {
    
    // 计算 点中了九个item中的第 X 个
    int index = (int)sender.tag;
    // 创建 通知:用于通知点击的tag
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMESECONDPATHSELECT" object:self userInfo:@{@"index":@(index)}];
}

#pragma mark - collectionView dataSource 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.brokersArray.count;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 97);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HorizonalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HorizonalCollectionViewCell" forIndexPath:indexPath];
    
    cell.dic = self.brokersArray[indexPath.item];
    
    return cell;
}

#pragma mark - collectionView delegate 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.tapPromediusBlock(self.brokersArray[indexPath.item]);
}

#pragma mark - lazy load

- (UIScrollView *)myScrollView {
    
    if (!_myScrollView) {
        
        CGFloat bgViewWidth = self.bgView.frame.size.width;
        
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39, bgViewWidth, self.bgView.frame.size.height-40)];
        
        _myScrollView.backgroundColor = [UIColor whiteColor];
        
        _myScrollView.contentOffset = CGPointMake(self.indexSegment*bgViewWidth, 0);    // 根据  self.indexSegment 确定scrollVie 的偏移位置
        
        _myScrollView.delegate = self;
        
        _myScrollView.pagingEnabled = YES;
        
        _myScrollView.showsHorizontalScrollIndicator = NO;
        int tag = 0;
        for (int i = 0; i < 3; i++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*bgViewWidth, 0, bgViewWidth, _myScrollView.frame.size.height)];
            
            [_myScrollView addSubview:view];
            
            switch (i) {
                case 0: // 我要找房
                {
                    HomeHorizontalCellView *buttonView = [[[NSBundle mainBundle] loadNibNamed:@"HomeHorizontalCellView" owner:self options:nil] objectAtIndex:0];
                    
                    buttonView.frame = CGRectMake(8, 0, 76, 97);
                    buttonView.imageView.image = [UIImage imageNamed:@"home_standar"];
                    buttonView.nameLabel.text = @"标准";
                    buttonView.tagButton.tag = tag;
                    [buttonView.tagButton addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:buttonView];
                    
                    buttonView.goldmedalImageView.hidden = YES;
                    buttonView.honourLabel.hidden = YES;
                    tag++;
                }
                    break;
                case 1: // 我是业主
                {
                    HomeHorizontalCellView *buttonView = [[[NSBundle mainBundle] loadNibNamed:@"HomeHorizontalCellView" owner:self options:nil] objectAtIndex:0];
                    buttonView.frame = CGRectMake(8, 0, 76, 97);
                    buttonView.imageView.image = [UIImage imageNamed:@"home_publish"];
                    buttonView.nameLabel.text = @"我要发布";
                    buttonView.tagButton.tag = tag;
                    
                    buttonView.goldmedalImageView.hidden = YES;
                    buttonView.honourLabel.hidden = YES;
                    [buttonView.tagButton addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:buttonView];
                    tag++;
                }
                    break;
                case 2: // 经纪人
                {
                    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
                    
                    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                    
                    layout.minimumLineSpacing = 0;
                    
                    layout.minimumInteritemSpacing = 0;
                    
                    self.myCollectionView = [[UICollectionView alloc] initWithFrame:view.bounds collectionViewLayout:layout];
                    self.myCollectionView.backgroundColor = [UIColor whiteColor];
                    
                    self.myCollectionView.delegate = self;
                    self.myCollectionView.dataSource = self;
                    
                    [view addSubview:self.myCollectionView];
                    
                    [self.myCollectionView registerNib:[UINib nibWithNibName:@"HorizonalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HorizonalCollectionViewCell"];
                
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        _myScrollView.contentSize = CGSizeMake(3*bgViewWidth, 0);

    }
    return _myScrollView;
}

- (HMSegmentedControl *)segmentedControl{
    
    if (!_segmentedControl) {
        
        self.segmentedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.indexSegment*self.frame.size.width/3, 0, self.frame.size.width/3, 40)];
        
        self.segmentedImageView.image = segmentImageArr[self.indexSegment];
        
        [self.bgView addSubview:self.segmentedImageView];
        
        // 初始化 segmentedControl
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"我要找房",@"我是业主",@"经纪人"]];
        
        _segmentedControl.frame = CGRectMake(0, 0, self.bgView.frame.size.width, 40);
        // 分段控件的背景颜色
        _segmentedControl.backgroundColor = [UIColor clearColor];
        // 指示器的位置
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        // 分段控件文字的大小及颜色
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:GRAY_9e,NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
        
        // 被选中后的文字大小与文字
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:BLACK_42,NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
        
        [_segmentedControl setSelectedSegmentIndex:self.indexSegment];
        
        __weak typeof(self) weakSelf = self;
        
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            
            weakSelf.segmentedImageView.frame = CGRectMake(index * self.frame.size.width/3, 0, self.frame.size.width/3, 40);
            switch (index) {
                case 0:
                    weakSelf.segmentedImageView.image = [UIImage imageNamed:@"segment_1.png"];
                    break;
                case 1:
                    weakSelf.segmentedImageView.image = [UIImage imageNamed:@"segment_2.png"];
                    break;
                case 2:
                    weakSelf.segmentedImageView.image = [UIImage imageNamed:@"segment_3.png"];
                    break;
                default:
                    break;
            }
            
            weakSelf.indexSegment = (long)index;
            
            weakSelf.myScrollView.contentOffset = CGPointMake(index*self.bgView.frame.size.width, 0);
            
        }];
        
        
    }
    
    return _segmentedControl;
}

-(UIView*)bgView {
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = GRAY_F5;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
        
        [self.bgView addSubview:self.segmentedControl];
        [self.bgView addSubview:self.myScrollView];
    }
    return _bgView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

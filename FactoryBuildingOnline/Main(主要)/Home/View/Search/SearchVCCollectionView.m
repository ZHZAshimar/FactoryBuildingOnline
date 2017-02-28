//
//  SearchVCCollectionView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/16.
//  Copyright © 2016年 XFZY. All rights reserved.
//  Developer :Ashimar_ZHZ

#import "SearchVCCollectionView.h"

#import "TextCollectionViewCell.h"
#import "SearchHeadReusableViewCollectionReusableView.h"
#import "WantedMessageModel.h"
#import "SearchResultCollectionViewCell.h"

@interface SearchVCCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    CGFloat cellWidth;
}
@end

@implementation SearchVCCollectionView

- (void)dealloc {
    
    self.delegate = nil;
    
    self.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.dataArray = [NSMutableArray array];
        
        self.historyArray = [NSArray array];
        
        [self loadCollection];
    }
    return self;
}

/*
 * collectionView 的设置
 */
- (void)loadCollection {
     
    self.delegate = self;
    
    self.dataSource = self;
    
    [self registerClass:[TextCollectionViewCell class] forCellWithReuseIdentifier:@"TextCollectionViewCell"];
    
    [self registerClass:[SearchHeadReusableViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headVeiw"];
    
    [self registerClass:[SearchResultCollectionViewCell class] forCellWithReuseIdentifier:@"SearchResultCollectionViewCell"];
    
//    self.alignmentRectInsets
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    NSLog(@"--%@",dataArray);
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
     [self reloadData];
    }
    
    _dataArray = dataArray;
    _dataArray = (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];   // 对数组进行数据
    [self reloadData];
}
#pragma mark - 搜索历史的数组
- (void)setHistoryArray:(NSArray *)historyArray {
    
    _historyArray = historyArray;
    
    [self reloadData];
}

#pragma mark- 清除搜索记录
- (void)cleanHistoryTag:(UIButton *)sender {
    
    self.deleteFile(YES);
    
}

#pragma mark - collectionView datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
        return CGSizeZero;
    }
#pragma mark - one defferent
    return CGSizeMake(Screen_Width, Screen_Height*41/568);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reuseableView = [UICollectionReusableView new];
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        SearchHeadReusableViewCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headVeiw" forIndexPath:indexPath];
        
        headView.hidden = NO;
        
        if (self.historyArray.count == 0) {
            
            headView.cleanBtn.enabled = NO;
            headView.historyLabel.text = @"暂无搜索记录";
        } else {
            
            headView.cleanBtn.enabled = YES;
            headView.historyLabel.text = @"搜索历史";
        }
        
        [headView.cleanBtn addTarget:self action:@selector(cleanHistoryTag:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (self.dataArray.count > 0) {     // 当拿到 数据源时，隐藏headView
            headView.hidden = YES;
        }
        
        return headView;
    }
    return reuseableView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
//        NSLog(@"%d",self.dataArray.count);
        return self.dataArray.count;
        
    } else {
        
        return self.historyArray.count;
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count > 0) {
//        CGFloat height = Screen_Height*44/568;
#pragma warning(error:There have a problem that Only show one cell when I used "return CGSizeMake(Screen_Width, height);")
        return CGSizeMake(Screen_Width, 44);
        
    } else {
        
        cellWidth = [NSString widthForString:self.historyArray[indexPath.item] fontSize:[UIFont adjustFontSize:12.0f] andHeight:20] + 20;
        NSLog(@"cell is width %f",cellWidth);
        return CGSizeMake(cellWidth, Screen_Height*25/568);
        
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (self.dataArray.count >0 ) {
        
        return UIEdgeInsetsZero;
        
    }
    
    return UIEdgeInsetsMake(10, 19, 10, 19);
    
}

/// 设置纵向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
        return 0;
    }
    
    return 5.0f;
}

/// 设置单元格间的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.dataArray.count > 0) {
        return 0;
    }
    return 5.0f;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    if (self.dataArray.count > 0) {
        
        return [self dataCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        
    } else {
        
        return [self historyCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        
    }
    
    return cell;
}

/// data cell
- (UICollectionViewCell*)dataCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchResultCollectionViewCell" forIndexPath:indexPath];
    cell.dic = self.dataArray[indexPath.item];

    return cell;
}

/// 历史记录的cell
- (UICollectionViewCell*)historyCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextCollectionViewCell" forIndexPath:indexPath];
    
    cell.label.text = self.historyArray[indexPath.item];
    
    return cell;
}

#pragma mark - collectionView delegage  
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count > 0) {
        
        NSDictionary *tmpDic = self.dataArray[indexPath.item];
        
        self.factoryDetail(tmpDic);
        
    } else {
        
        self.tapSearch(self.historyArray[indexPath.item]);
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


///// data cell
//- (UICollectionViewCell*)dataCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    SearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchResultCollectionViewCell" forIndexPath:indexPath];
//    WantedMessageModel *model = self.dataArray[indexPath.item];
//    // 设置富文本
//    NSString *string = model.ftModel.title;
//    
//    NSRange range = [string rangeOfString:self.keyStr]; // 获取匹配的下标
//    if (range.location != NSNotFound) {
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
//        [attributeStr addAttribute:NSForegroundColorAttributeName value:GREEN_1ab8 range: range];
//        
//        cell.label.attributedText = attributeStr;
//    } else {
//        
//        string = model.ftModel.description_factory;
//        
//        range = [string rangeOfString:self.keyStr]; // 获取匹配的下标
//        if (range.location != NSNotFound) {
//            
//            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
//            [attributeStr addAttribute:NSForegroundColorAttributeName value:GREEN_1ab8 range: range];
//            
//            cell.label.attributedText = attributeStr;
//        } else {
//            
//            cell.label.text = string;
//        }
//    }
//    
//    return cell;
//}

@end

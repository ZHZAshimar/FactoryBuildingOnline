//
//  ScanReserveViewController.m
//  FactoryBuildingOnline
//
//  Created by Ashimar ZHENG on 2017/2/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ScanReserveViewController.h"
#import "MyReserveCollectionViewCell.h"


@interface ScanReserveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat oneLineHeight;  // 一行文字的高度
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableArray *heightmArray;
@property (nonatomic, strong) NSMutableArray *selectmArray;

@end

@implementation ScanReserveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVCName:@"我发布的预约" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
    
    self.mArray = [NSMutableArray array];
    self.heightmArray = [NSMutableArray array];
    self.selectmArray = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [self.selectmArray addObject:@(0)];
        
    }
    NSLog(@"%@",self.selectmArray);
    [self.mArray addObject:@{@"content":@"你好！",@"type":@(0)}];
    [self.mArray addObject:@{@"content":@"奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！",@"type":@(0)}];

    [self.mArray addObject:@{@"content":@"拗口给哪了；放假哦潍坊万法皆空；晚来风急欧文i二纺机问佛为哦弄！",@"type":@(0)}];
    
    [self.mArray addObject:@{@"content":@"你好！",@"type":@(0)}];
    [self.mArray addObject:@{@"content":@"奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！",@"type":@(0)}];
    [self.mArray addObject:@{@"content":@"拗口给哪了；放假哦潍坊万法皆空；晚来风急欧文i二纺机问佛为哦弄！",@"type":@(0)}];
    
    [self.mArray addObject:@{@"content":@"你好！",@"type":@(1)}];
    [self.mArray addObject:@{@"content":@"奥你干撒离开家送到家分开了十几分南斯拉夫就考试地方沃尔夫两节课撒女匡山街道弗雷斯科佛问哦i教父i额！",@"type":@(1)}];
    [self.mArray addObject:@{@"content":@"拗口给哪了；放假哦潍坊万法皆空；晚来风急欧文i二纺机问佛为哦弄！",@"type":@(1)}];
    
    [self.view addSubview:self.myCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat contentHeight = [NSString getHeightOfAttributeRectWithStr:self.mArray[indexPath.item][@"content"] andSize:CGSizeMake(Screen_Width-33, 2000) andFontSize:[UIFont adjustFontSize:14] andLineSpace:10];
    
    // 将拿到高度添加到 高度数组中
    [self.heightmArray addObject:@(contentHeight)];
    
    oneLineHeight = [NSString getHeightOfAttributeRectWithStr:@"计算单一行文字的高度" andSize:CGSizeMake(Screen_Width-33, 20000) andFontSize:[UIFont adjustFontSize:14] andLineSpace:10];
    // 计算行数
    CGFloat lineNum = contentHeight/oneLineHeight;
    
    if (lineNum > 2) {  // 当行数大于二的时候
        
        BOOL  isShow= [self.selectmArray[indexPath.item] boolValue];
        
        if (isShow) {
            
            return CGSizeMake(Screen_Width, contentHeight+20+13+7+8+10+8);
            
        } else {
        
            return CGSizeMake(Screen_Width, oneLineHeight*2+20+13+7+8+10+8);
        }
    } else if (lineNum > 1 && lineNum <=2 ) {   // 行数在 （1,2]之间
        return CGSizeMake(Screen_Width, contentHeight+20+13+10+8);
    } else { // 一行的时候
        return CGSizeMake(Screen_Width, contentHeight+20+13+8+8);
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyReserveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyReserveCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.mArray[indexPath.item];
    
    CGFloat lineNum = [self.heightmArray[indexPath.item] floatValue]/oneLineHeight;
    
    if (lineNum > 2) {

        cell.contentLabelBttom.constant = 23.5;
        BOOL isShow = [self.selectmArray[indexPath.item] boolValue];
        
        if (isShow) {
            cell.myImageView.image = [UIImage imageNamed:@"reserve_up"];
        } else {
            cell.myImageView.image = [UIImage imageNamed:@"reserve_down"];
        }
        cell.contentLabel.attributedText = [NSString attributedString:dic[@"content"] andTextWidth:5000 andLineSpace:10];
    } else if (lineNum > 1 && lineNum <= 2 ){
       
        cell.contentLabelBttom.constant = 8;
        
        cell.contentLabel.attributedText = [NSString attributedString:dic[@"content"] andTextWidth:100 andLineSpace:10];
    } else {
        cell.contentLabelBttom.constant = 8;
        
        cell.contentLabel.text = dic[@"content"];
    }
    
    
//    self.contentLabel.attributedText = [NSString attributedString:contentStr andTextWidth:5000 andLineSpace:10];
    
    cell.dataDic = dic;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (oneLineHeight *2 < [self.heightmArray[indexPath.item] floatValue]) {
        NSLog(@"点中要展开的Cell");
        BOOL isChoose = [self.selectmArray[indexPath.item] intValue];
        
        [self.selectmArray replaceObjectAtIndex:indexPath.item withObject:@(!isChoose)];
        [self.myCollectionView reloadData];
    }
    
}

- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = GRAY_F5;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView registerClass:[MyReserveCollectionViewCell class] forCellWithReuseIdentifier:@"MyReserveCollectionViewCell"];
    }
    return _myCollectionView;
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

//
//  HomeSecondPathCellView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeSecondPathCellView.h"
#import "HomeSecondPathCollectionViewCell.h"

@interface HomeSecondPathCellView()
{
    NSInteger indexOfCell;
}
@end

@implementation HomeSecondPathCellView

- (void)dealloc {
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RELOADDATA" object:nil];
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        
        self.textArray = @[@[@"发布求租",@"地图找房",@"专人服务"],@[@"发布招租",@"专人服务"],@[@"悬赏栏"]];
        _imageArray = @[[UIImage imageNamed:@"my_list_icon5"]];
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataOfCollectionView:) name:@"RELOADDATA" object:nil];
    }
    
    
    return self;
}

- (void)reloadDataOfCollectionView:(NSNotification *)sender {
    [_myCollectionView reloadData];
}


#pragma mark - collectionView delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *tmpArr = [NSArray array];
    switch (self.collect_type) {
        case LOOKING_ROOM_TYPE:
        {
            NSArray *tmpArr = self.textArray[LOOKING_ROOM_TYPE];
            return  tmpArr.count;
        }
            break;
        case INTERMEDIARY_AGENT_TYPE:
        {
            NSArray *tmpArr = self.textArray[INTERMEDIARY_AGENT_TYPE];
            return  tmpArr.count;
        }
            break;
        default:
        {
            NSArray *tmpArr = self.textArray[OWNER_TYPE];
            return  tmpArr.count;
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.frame.size.width/6, 86);
    
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 5.0f;
//}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return self.frame.size.width/12;
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.frame.size.width/20, 0, self.frame.size.width/12);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeSecondPathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSecondPathCollectionViewCell" forIndexPath:indexPath];
    if (self.textArray.count > 0){
        
        switch (self.collect_type) {
            case LOOKING_ROOM_TYPE:
            {
                cell.imageView.image = self.imageArray[0];
                
                cell.titleLabel.text = self.textArray[LOOKING_ROOM_TYPE][indexPath.item];
            }
                break;
            case INTERMEDIARY_AGENT_TYPE:
            {
                cell.imageView.image = self.imageArray[0];
                
                cell.titleLabel.text = self.textArray[INTERMEDIARY_AGENT_TYPE][indexPath.item];
            }
                break;
            case OWNER_TYPE:
            {
                cell.imageView.image = self.imageArray[0];
                
                cell.titleLabel.text = self.textArray[OWNER_TYPE][indexPath.item];
            }
                break;
            default:
                break;
        }
    
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 计算 点中了九个item中的第X 个
    int index = indexPath.item + 3 * self.collect_type;
    // 创建 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMESECONDPATHSELECT" object:self userInfo:@{@"index":@(index)}];
}

#pragma mark - lazyload -
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_myCollectionView];
        
        _myCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_myCollectionView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,_myCollectionView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_myCollectionView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,_myCollectionView)]];
        
        [self.myCollectionView registerClass:[HomeSecondPathCollectionViewCell class] forCellWithReuseIdentifier:@"HomeSecondPathCollectionViewCell"];
    }
    
    return _myCollectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

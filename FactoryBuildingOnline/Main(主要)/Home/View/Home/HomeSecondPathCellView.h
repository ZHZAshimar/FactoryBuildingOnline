//
//  HomeSecondPathCellView.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    
    LOOKING_ROOM_TYPE,
    INTERMEDIARY_AGENT_TYPE,
    OWNER_TYPE,
    
} COLLECT_TYPE;

@interface HomeSecondPathCellView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, assign) COLLECT_TYPE collect_type;

@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, strong) NSArray *imageArray;

@end

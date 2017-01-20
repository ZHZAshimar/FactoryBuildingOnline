//
//  ExpertAearHeadCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AREABLOCK) (NSInteger index, NSString *areaStr);

@interface ExpertAearHeadCollectionReusableView : UICollectionReusableView

@property (nonatomic, copy) AREABLOCK areaBlock;

@end

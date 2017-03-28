//
//  ECHouseInputView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NEXTBLOCK) (NSInteger tagIndex);

@interface ECHouseInputView : UIView

@property (nonatomic, copy) NEXTBLOCK nextBlock;

@end

//
//  ECTwoButtonFooter.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAGBLOCK) (NSInteger tagIndex);

@interface ECTwoButtonFooter : UIView

@property (nonatomic, copy) TAGBLOCK tagBlock;

@end

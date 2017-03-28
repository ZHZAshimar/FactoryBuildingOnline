//
//  ECFactoryBusinessInputView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/28.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NEXTBLOCK) (NSInteger tagIndex);

@interface ECFactoryBusinessInputView : UIView

@property (nonatomic, copy) NEXTBLOCK nextBlock;




@end

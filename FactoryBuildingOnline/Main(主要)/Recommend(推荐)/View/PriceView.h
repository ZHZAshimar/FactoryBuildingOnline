//
//  PriceView.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>



/*
 *  block 价格、面积回调
 */
typedef void(^PriceBlock)(NSString *price,NSInteger index,NSIndexPath *indexPath);

// 点击类型的枚举，价格/面积
typedef enum{
    
    PRICE_TYPE, 
    AREA_TYPE,
    
}SEGMENT_INDEX_TYPE;


@interface PriceView : UIView

@property (nonatomic, copy)PriceBlock priceBlock;

@property (nonatomic, assign)SEGMENT_INDEX_TYPE segmentIndex_type;

@property (nonatomic, strong) UITextField *lowPriceTF;
@property (nonatomic, strong) UITextField *hightPriceTF;
/*记录上一次选中的index*/
@property (nonatomic, assign) NSInteger selectIndex;

- (id)initWithFrame:(CGRect)frame withData:(NSArray *)array withIndexType:(NSUInteger)type;

@end

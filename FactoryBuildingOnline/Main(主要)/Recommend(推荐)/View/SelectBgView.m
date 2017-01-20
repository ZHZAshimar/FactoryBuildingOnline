//
//  SelectBgView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SelectBgView.h"

@interface SelectBgView()

@property (nonatomic, assign) NSInteger index;
@end

@implementation SelectBgView

- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.alphaView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.alphaView];
        
        self.alphaView.backgroundColor = BLACK_1a;
        self.alphaView.alpha = 0.38;
        self.alphaView.userInteractionEnabled = YES;
        
        
        switch (index) {
            case 0:
            {
                // leftTableView
                self.leftTableView = [[LeftTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width/2, 250)];
                self.leftTableView.backgroundColor = GRAY_235;
                [self addSubview:self.leftTableView];
                
                // rightTableView
                self.rightTableView = [[RightTableView alloc] initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 250)];
                
                self.rightTableView.backgroundColor = [UIColor whiteColor];
                
                [self addSubview:self.rightTableView];
                
                
            }
                break;
            case 1:
            {
                self.priceView = [[PriceView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 230) withData:@[@"不限",@"3-7元/m²",@"7-10元/m²",@"10-13元/m²",@"大于13元/m²"] withIndexType:0];
                [self addSubview:self.priceView];
            }
                break;
            case 2:
            {
                self.priceView = [[PriceView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 230) withData:@[@" 不限 ",@"200-700m²",@"700-1200m²",@"1200-1700m²",@"大于1700m²"] withIndexType:1];
                [self addSubview:self.priceView];
            }
                break;
            default:
                break;
        }
        
        
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

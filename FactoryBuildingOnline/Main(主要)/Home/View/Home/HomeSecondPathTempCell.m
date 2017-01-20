//
//  HomeSecondPathTempCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeSecondPathTempCell.h"

@implementation HomeSecondPathTempCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (HomeSecondPathCellView *)secondPathCellView {
    
    if (!_secondPathCellView) {
        
        _secondPathCellView = [[HomeSecondPathCellView alloc] init];
        
        [self addSubview: _secondPathCellView];
        
        _secondPathCellView.backgroundColor = [UIColor clearColor];
        
        _secondPathCellView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *view = _secondPathCellView;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        
    }
    
    return _secondPathCellView;
}

@end

//
//  HomeCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell


- (HomeOfHomeViewController *)homeOfHomeVC {
    
    if (!_homeOfHomeVC) {
        
        _homeOfHomeVC = [[HomeOfHomeViewController alloc] init];
        
        [self addSubview:_homeOfHomeVC.view];
        
        _homeOfHomeVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *view = _homeOfHomeVC.view;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-(100)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        
    }
    return _homeOfHomeVC;
}
// 筛选的Cell
- (RecommendViewController *)recommendOfHomeVC {
    
    if (!_recommendOfHomeVC) {
        
        _recommendOfHomeVC = [[RecommendViewController alloc] init];
        
        [self addSubview:_recommendOfHomeVC.view];
        
        _recommendOfHomeVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *view = _recommendOfHomeVC.view;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-10)-[view]-(100)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        
    }
    return _recommendOfHomeVC;
}


- (ExpertOfHomeViewController *)expertOfHomeVC {
    
    if (!_expertOfHomeVC) {
        
        _expertOfHomeVC = [[ExpertOfHomeViewController alloc] init];
        
        [self addSubview:_expertOfHomeVC.view];
        
        _expertOfHomeVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *view = _expertOfHomeVC.view;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-(100)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
    }
    return _expertOfHomeVC;
}

- (BoutiqueViewController *)boutiqueVC {
    
    if (!_boutiqueVC) {
        _boutiqueVC = [[BoutiqueViewController alloc] init];
        
        [self addSubview:_boutiqueVC.view];
        
        _boutiqueVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *view = _boutiqueVC.view;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,view)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, view)]];
    }
    return _boutiqueVC;
}

@end

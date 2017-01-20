//
//  AddCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "AddCollectionViewCell.h"

@implementation AddCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"AddCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            
            return nil;
            
        }
        
        if (![[arrayOfView objectAtIndex:0] isKindOfClass:[AddCollectionViewCell class]]) {
            
            return nil;
            
        }
        
        self = [arrayOfView objectAtIndex:0];
    }
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

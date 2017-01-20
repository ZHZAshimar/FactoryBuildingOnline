//
//  PictureCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/21.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"PictureCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            
            return nil;
            
        }
        
        if (![[arrayOfView objectAtIndex:0] isKindOfClass:[PictureCollectionViewCell class]]) {
            
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

//
//  NDynamicFactoryCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/13.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NDynamicFactoryCollectionViewCell.h"
#import "SecurityUtil.h"
@implementation NDynamicFactoryCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NDynamicFactoryCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfViews[0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
//    self.titleLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.titleLabel.font.pointSize weight:0.2]];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    NSString *imageStr = [SecurityUtil decodeBase64String:dataDic[@"map_url"]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    self.titleLabel.text = dataDic[@"title"];
    self.contentLabel.text = [NSString stringWithFormat:@"%@km",dataDic[@"range"]];
}

/*
 "browse_count" = 0;
 id = 12;
 "map_url" = "aHR0cDovL29pNjUzZXphbi5ia3QuY2xvdWRkbi5jb20vZmFjdG9yeV8wMjQyZWNjZi1hNTFiLWU2NGItYTcxNi1hNTdiYmJkYWRhMjk=";
 range = "2226.302";
 title = "\U8d85\U5927\U5382\U623f";
 */

@end

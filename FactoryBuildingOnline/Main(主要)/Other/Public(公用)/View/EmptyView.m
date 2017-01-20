//
//  EmptyView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/10.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "EmptyView.h"

#define swidth [[UIScreen mainScreen] bounds].size.width
#define sheight [[UIScreen mainScreen] bounds].size.height

@interface EmptyView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *emptyLablel;

@end

@implementation EmptyView

#pragma mark - 创建 文字 view
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];

    if (self) {
        

        [self addSubview:self.emptyLablel];
        
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(swidth/2-image.size.width/2, sheight/2-image.size.height-30, image.size.width, image.size.height)];
    self.imageView.image = image;
    [self addSubview:self.imageView];
}

- (void)setEmptyStr:(NSString *)emptyStr {
    
    _emptyStr = emptyStr;
    
    self.emptyLablel.text = _emptyStr;
}

- (UILabel *)emptyLablel {

    if (!_emptyLablel) {
        _emptyLablel = [[UILabel alloc] initWithFrame:CGRectMake(0, sheight/2, swidth, sheight/2)];
        _emptyLablel.center = self.center;
        _emptyLablel.textColor = BLACK_42;
        _emptyLablel.font = [UIFont systemFontOfSize:14.0f];
        _emptyLablel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLablel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

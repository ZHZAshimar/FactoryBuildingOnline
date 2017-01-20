//
//  ClusterAnnotation.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/31.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ClusterAnnotation.h"
#import "NSString+Judge.h"
@implementation ClusterAnnotation

@synthesize size = _size;
@synthesize areaStr = _areaStr;
@synthesize showPaoPao = _showPaoPao;
@synthesize area_id = _area_id;
@end

@implementation ClusterAnnotationView

@synthesize size = _size;
@synthesize label = _label;
@synthesize areaStr = _areaStr;
@synthesize imageView = _imageView;
@synthesize strethImage = _strethImage;
@synthesize showPaoPao = _showPaoPao;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 44.f, 22.f)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:10];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.masksToBounds = YES;
        _label.layer.cornerRadius = 22;
        _label.numberOfLines = 0;
        [self addSubview:_label];
        self.alpha = 0.85;
        _showPaoPao = NO;
    }
    return self;
}

- (void) setShowPaoPao:(BOOL)showPaoPao {
    
    _showPaoPao = showPaoPao;
    if (_showPaoPao) {
        NSString *string = [NSString stringWithFormat:@"%@(%ld)",_areaStr,_size];
        CGFloat strWidth = [NSString widthForString:string fontSize:11.0f andHeight:30] + 10;
        
        UIImage *leftImage = [UIImage imageNamed:@"paopao_left"];
        leftImage = [leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 9) resizingMode:UIImageResizingModeStretch];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, strWidth/2, 35)];
        leftImageView.image = leftImage;
        [self addSubview:leftImageView];
        
        UIImage *rightImage = [UIImage imageNamed:@"paopao_right"];
        rightImage = [rightImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 9, 10, 10) resizingMode:UIImageResizingModeStretch];
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftImageView.frame.size.width, 0, strWidth/2, 35)];
        rightImageView.image = rightImage;
        [self addSubview:rightImageView];
        
        [self bringSubviewToFront:_label];
        
        _label.frame = CGRectMake(0.f, 0.f, strWidth, 25);
        _label.text = string;
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor clearColor];
        
        [self setBounds:CGRectMake(0.f, 0.f, strWidth, 35)];
        
    } else {
        _imageView.hidden = YES;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
}

- (void)setAreaStr:(NSString *)areaStr {
    _areaStr = areaStr;
    
    self.label.text = [NSString stringWithFormat:@"%@\n%ld",areaStr, _size];
}

- (void)setSize:(NSInteger)size {
    _size = size;
//    if (_size == 1) {
//        self.label.hidden = YES;
//        self.imageView.hidden = YES;
//        self.pinColor = BMKPinAnnotationColorPurple;
//        return;
//    }
    self.label.hidden = NO;
    if (size > 20) {
        self.label.backgroundColor = [UIColor redColor];
    } else if (size > 10) {
        self.label.backgroundColor = [UIColor purpleColor];
    } else if (size > 5) {
        self.label.backgroundColor = [UIColor orangeColor];
    } else {
        self.label.backgroundColor = [UIColor blueColor];
    }
    //    self.label.text = [NSString stringWithFormat:@"%@\n%d", self.size];
}

- (UIImage *)stretchableImage {
    UIImage *image = [UIImage imageNamed:@"paopao"];
    return [image stretchableImageWithLeftCapWidth:image.size.width *0.7 topCapHeight:image.size.height*0.5];
}
@end

//
//  DetailPictureCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "DetailPictureCollectionViewCell.h"
#import "SJAvatarBrowser.h"
#import "SecurityUtil.h"

@interface DetailPictureCollectionViewCell()<ImagePlayerViewDelegate>

@end

@implementation DetailPictureCollectionViewCell

- (void)dealloc {
    self.imagePlayerView.imagePlayerViewDelegate = nil;

}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"DetailPictureCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            return nil;
        }
        if (![arrayOfView[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfView[0];
        
        self.imageData = [NSArray array];   // 初始化图片数组
        
        [self loadImagePlayerView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backBtnView.layer.cornerRadius = 5;
    self.backBtnView.layer.masksToBounds = YES;
    
    self.likeBtnView.layer.cornerRadius = 5;
    self.likeBtnView.layer.masksToBounds = YES;
    
    self.shareView.layer.cornerRadius = 5;
    self.shareView.layer.masksToBounds = YES;
    
    self.indexView.layer.cornerRadius = 5;
    self.indexView.layer.masksToBounds = YES;
    // 文字适应
    self.indexLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.indexLabel.font.pointSize]];
    self.headLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.headLabel.font.pointSize weight:0.5]];
    self.monthlyLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.monthlyLabel.font.pointSize]];
    self.daythlyLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.daythlyLabel.font.pointSize]];
    self.areaLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.areaLabel.font.pointSize]];
    // 红色字体下面的黑色字体的自适应
    self.mLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.mLabel.font.pointSize]];
    self.dLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.dLabel.font.pointSize]];
    self.aLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.aLabel.font.pointSize]];
}

- (void)loadImagePlayerView {
    
    self.imagePlayerView.imagePlayerViewDelegate = self;
    
    self.imagePlayerView.scrollInterval = 2.0f;
    
    self.imagePlayerView.hidePageControl = YES;
    // 重新加载数据
    [self.imagePlayerView reloadData];
}

- (void)setImageData:(NSArray *)imageData {
    
    _imageData = imageData;
    self.indexLabel.text = [NSString stringWithFormat:@"1/%ld",self.imageData.count];
    [self.imagePlayerView reloadData];
}

- (void)setFtModel:(FactoryModel *)ftModel {
    _ftModel = ftModel;
    
    self.headLabel.text = [NSString stringWithFormat:@"%@",ftModel.title];
    
    CGFloat monthlyPrice = [ftModel.price floatValue] *[ftModel.range floatValue];
    if (monthlyPrice >= 1000000) {
        
        self.monthlyLabel.text = [NSString stringWithFormat:@"%.2f万元",monthlyPrice/1000000.00];
    } else {
        self.monthlyLabel.text = [NSString stringWithFormat:@"%.0f元",monthlyPrice/1.0];
    }
    self.daythlyLabel.text = [NSString stringWithFormat:@"%.1f元/月",[ftModel.price floatValue]/1.0];
    self.areaLabel.text = [NSString stringWithFormat:@"%@m²",ftModel.range];
    NSArray *tmpArr = [NSString arrayWithJsonString:ftModel.image_urls];
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSString *str in tmpArr) {
        NSString *url = [SecurityUtil decodeBase64String:str];
        [mArr addObject:url];
    }
    
    self.imageData = mArr;
 
}

- (void)setBrokerFactoryModel:(ProMediumFactoryModel *)brokerFactoryModel {
    _brokerFactoryModel = brokerFactoryModel;
    
    self.headLabel.text = [NSString stringWithFormat:@"%@",brokerFactoryModel.title];
    
    CGFloat monthlyPrice = [brokerFactoryModel.price floatValue] *[brokerFactoryModel.range floatValue];
    self.monthlyLabel.text = [NSString stringWithFormat:@"%.0f元/月",monthlyPrice];
    self.daythlyLabel.text = [NSString stringWithFormat:@"%@元/月/m²",brokerFactoryModel.price];
    self.areaLabel.text = [NSString stringWithFormat:@"%@",brokerFactoryModel.range];
    NSArray *tmpArr = [NSString arrayWithJsonString:brokerFactoryModel.image_urls];
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSString *str in tmpArr) {
        NSString *url = [SecurityUtil decodeBase64String:str];
        [mArr addObject:url];
    }
    
    self.imageData = mArr;
    
}


#pragma mark - imageViewdelegate
/**
 *  Number of items
 *
 *  @return Number of items
 */
- (NSInteger)numberOfItems {
    return self.imageData.count;
}

/**
 *  Init imageview
 *
 *  @param imagePlayerView ImagePlayerView object
 *  @param imageView       UIImageView object
 *  @param index           index of imageview
 */
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index {
    
    NSString *imageURL = self.imageData[index];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:PLACEHOLDER_IMAGE];
    
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index {
    NSLog(@"you tap the %ld picture",index);
    
    NSMutableArray *urlArray = [NSMutableArray array];
    
    NSMutableArray *smallArray = [NSMutableArray array];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    for (NSString *url in self.imageData) {
        [urlArray addObject:url];
        
        [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
        
        [smallArray addObject:imageView];
    }
    [SJAvatarBrowser showImageBrowserWithImageURL:urlArray withSmallImageArr:smallArray imageIndex:index];
    
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didScorllIndex:(NSInteger)index {
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.imageData.count];
}

@end

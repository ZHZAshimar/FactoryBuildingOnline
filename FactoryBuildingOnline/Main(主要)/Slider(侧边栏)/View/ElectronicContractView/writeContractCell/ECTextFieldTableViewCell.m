//
//  ECTextFieldTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECTextFieldTableViewCell.h"

@interface ECTextFieldTableViewCell ()<UITextViewDelegate>
@property (nonatomic, strong)UILabel *placeholdLabel;    // 提示文字

@end

@implementation ECTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.myTextView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
#pragma mark - 重写 setter 方法
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    
    CGFloat titleStrWidth = [NSString widthForString:_titleStr fontSize:[UIFont adjustFontSize:11] andHeight:100];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, titleStrWidth, self.frame.size.height)];
    
    titleLabel.textColor = BLACK_33;
    titleLabel.text = _titleStr;
    titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]];
    
    [self addSubview:titleLabel];
    
    self.myTextView.frame = CGRectMake(12+titleStrWidth+10, 4, Screen_Width-titleStrWidth-24-10, self.frame.size.height-8);
}

- (void)setPlaceholdStr:(NSString *)placeholdStr {
    _placeholdStr = placeholdStr;
    CGFloat strWidth = [NSString widthForString:_placeholdStr fontSize:[UIFont adjustFontSize:11] andHeight:100];
    
    CGFloat strHeight = [NSString getHeightOfAttributeRectWithStr:_placeholdStr andSize:CGSizeMake(Screen_Width, 100) andFontSize:[UIFont adjustFontSize:11] andLineSpace:0];
    
    self.placeholdLabel.frame = CGRectMake(0, 0, strWidth, strHeight);
    
    self.placeholdLabel.text = _placeholdStr;
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        
        self.placeholdLabel.hidden = NO;
        
    } else {
        
        self.placeholdLabel.hidden = YES;
    }
}
#pragma mark - lazy load
- (UILabel *)placeholdLabel {
    if (!_placeholdLabel) {
        _placeholdLabel = [[UILabel alloc] init];
        _placeholdLabel.textColor = BLACK_99;
        _placeholdLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
        
        [self.myTextView addSubview:_placeholdLabel];
    }
    return _placeholdLabel;
}

- (UITextView *)myTextView {
    
    if (!_myTextView) {
        _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 4, Screen_Width-24, self.frame.size.height-8)];
        _myTextView.delegate = self;
        _myTextView.textColor = BLACK_33;
        _myTextView.font = [UIFont systemFontOfSize: [UIFont adjustFontSize:11]];
//        _myTextView.backgroundColor = [UIColor yellowColor];
    }
    return _myTextView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

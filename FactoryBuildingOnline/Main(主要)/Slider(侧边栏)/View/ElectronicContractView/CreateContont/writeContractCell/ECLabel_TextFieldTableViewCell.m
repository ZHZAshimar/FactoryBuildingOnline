//
//  ECLabel_TextFieldTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECLabel_TextFieldTableViewCell.h"

@interface ECLabel_TextFieldTableViewCell ()<UITextViewDelegate>

@property (nonatomic, strong)UILabel *placeholdLabel;    // 提示文字

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation ECLabel_TextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.myTextView];
    }
    return self;
}

#pragma mark - 重写 setter 方法
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    
    [self addSubview:self.titleLabel];
    
    CGFloat titleStrWidth = [NSString widthForString:self.titleStr fontSize:[UIFont adjustFontSize:11] andHeight:100];
    self.titleLabel.frame = CGRectMake(12, 0, titleStrWidth, self.frame.size.height);
    NSLog(@"%@",self.titleStr);
    self.titleLabel.text = self.titleStr;
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.textBlock(textView.text);
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

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = BLACK_33;
        _titleLabel.text = _titleStr;
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]];
    }
    return _titleLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

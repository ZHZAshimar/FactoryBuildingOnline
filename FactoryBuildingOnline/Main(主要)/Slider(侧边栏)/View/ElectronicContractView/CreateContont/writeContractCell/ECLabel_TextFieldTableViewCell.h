//
//  ECLabel_TextFieldTableViewCell.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECLabel_TextFieldTableViewCell : UITableViewCell


typedef void(^TEXTBLOCK) (NSString *text);

@property (nonatomic, strong) UITextView *myTextView;

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) NSString *placeholdStr;

@property (nonatomic, copy) TEXTBLOCK textBlock;

@end

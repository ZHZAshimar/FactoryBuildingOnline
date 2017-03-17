//
//  ECTextFieldTableViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ONESUBVIEW,     // 只有一个textview 控件
    TWOSUBVIEW,     // textView 和 label
}UITYPE;

@interface ECTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *myTextView;
@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) NSString *placeholdStr;
@end

//
//  ECTextFieldTableViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AREATEXTBLOCK) (NSString *area);

@interface ECTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *myTextView;


@property (nonatomic, strong) NSString *placeholdStr;

@property (nonatomic, copy) AREATEXTBLOCK textBlock;

@end

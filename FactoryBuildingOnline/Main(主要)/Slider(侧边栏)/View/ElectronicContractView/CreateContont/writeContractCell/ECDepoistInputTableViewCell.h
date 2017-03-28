//
//  ECDepoistInputTableViewCell.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^INPUTBLOCK) (NSString *inputText);

@interface ECDepoistInputTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *depoistTF;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (nonatomic, copy) INPUTBLOCK inputBlock;

@end

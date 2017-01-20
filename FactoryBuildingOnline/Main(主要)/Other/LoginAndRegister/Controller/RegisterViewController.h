//
//  RegisterViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UITextField *msgNumTF;

@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

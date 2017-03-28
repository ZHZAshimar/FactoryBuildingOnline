//
//  ECWriteHouseContractViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECWriteContractViewController.h"

#import "ECHouseInputView.h"
#import "ECFactoryBusinessInputView.h"  // 厂房经济合同
#import "ECSignatureViewController.h"   // 画板的View

#import <IQKeyboardReturnKeyHandler.h>

@interface ECWriteContractViewController ()

@property (nonatomic, strong) ECHouseInputView *houseInputView;
@property (nonatomic, strong) ECFactoryBusinessInputView *factoryInputView;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;  // 键盘监听

@end

@implementation ECWriteContractViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigation];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setNavigation {
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftBack"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    btnItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
}

- (void)setContractType:(CONTRACTTYPE)contractType {
    _contractType = contractType;
    
    switch (contractType) {
        case FactoryBussiness_contract:
        {
            
            self.title = @"厂房经济合同";
            
            [self.view addSubview:self.factoryInputView];
        }
            break;
        case HouseRent_contract:
        {
            
            self.title = @"个人房屋租赁合同";
            
            [self.view addSubview:self.houseInputView];
        }
            break;
        default:
            break;
    }
}


- (ECHouseInputView *)houseInputView {
    
    if (!_houseInputView) {
        _houseInputView = [[ECHouseInputView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        
        __weak typeof(self) weakSelf = self;
        _houseInputView.nextBlock = ^(NSInteger tagindex) {
            ECSignatureViewController  *signatureVC = [ECSignatureViewController new];
            [weakSelf.navigationController pushViewController:signatureVC animated:YES];
        };
    }
    return _houseInputView;
}

- (ECFactoryBusinessInputView *)factoryInputView {
    
    if (!_factoryInputView) {
        _factoryInputView = [[ECFactoryBusinessInputView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        
        __weak typeof(self) weakSelf = self;
        _factoryInputView.nextBlock = ^(NSInteger tagindex) {
            ECSignatureViewController  *signatureVC = [ECSignatureViewController new];
            [weakSelf.navigationController pushViewController:signatureVC animated:YES];
        };
    }
    return _factoryInputView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

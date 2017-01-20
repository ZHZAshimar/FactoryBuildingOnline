//
//  DescriptViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "DescriptViewController.h"

@interface DescriptViewController ()<UITextViewDelegate>
{
    UILabel *placeHolderLabel;
}
@property (nonatomic, strong) UITextView *myTextView;
@end

@implementation DescriptViewController

- (void)dealloc {
    self.myTextView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"描述" andShowSearchBar:NO andTintColor:BLACK_42 andBackBtnStr:nil];
    [self addRightItemWithString:@"完成编辑"  andItemTintColor:BLACK_42];
    
    self.view.backgroundColor = GRAY_LIGHT;
    
    [self createView];
    
    if (self.descriptStr.length > 0) {
        placeHolderLabel.hidden = YES;
        self.myTextView.text = self.descriptStr;
    }
}

- (void)createView {
    
    // view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, Screen_Width-16, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = GRAY_198.CGColor;
    bgView.layer.borderWidth = 1;
    [self.view addSubview:bgView];
    
    // textView
    self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height-30)];
    self.myTextView.delegate = self;
    [bgView addSubview:self.myTextView];
    
    // 清空 textView 的button
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.frame = CGRectMake(bgView.frame.size.width-80, bgView.frame.size.height-30, 80, 30);
    [clearBtn setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [clearBtn setTintColor:GRAY_198];
    [clearBtn setTitle:@"清空所有" forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [clearBtn setTitleColor:GRAY_198 forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearTextViewTextAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:clearBtn];
    
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    placeHolderLabel.text = @"10字以上";
    placeHolderLabel.font = [UIFont systemFontOfSize:12.0f];
    placeHolderLabel.textColor = GRAY_198;
    [bgView addSubview:placeHolderLabel];
    
    
}

#pragma mark - 返回按钮
- (void)backAction {
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出将丢失内容，确定要退出么？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *oKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:oKAction];
    [alertControl addAction:cancelAction];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}
// 完成按钮
- (void) rightItemButtonAction {
    
    if (self.myTextView.text.length < 10) {
        ZHZAlertView *zhzAlertView = [[ZHZAlertView alloc] initWithFrame:self.view.bounds alertWord:@"请输入10个字以上~"];
        [self.view addSubview:zhzAlertView];
        return;
    }
    
    if (self.descriptBlock) {
        
        self.descriptBlock(self.myTextView.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 清空所有按钮
- (void) clearTextViewTextAction: (UIButton *)sender {
    
    if (self.myTextView.text.length > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清空描述内容么？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.myTextView.text = @"";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

#pragma mark - textView delegate 
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    placeHolderLabel.hidden = YES;
    
    return YES;
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

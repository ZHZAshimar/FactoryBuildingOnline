//
//  VersionInfoViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/2.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "VersionInfoViewController.h"

@interface VersionInfoViewController ()

@property (nonatomic, strong) UITextView *myTextView;

@end

@implementation VersionInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"版权信息" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    [self.view addSubview:self.myTextView];
    
}

- (UITextView *)myTextView {
    
    if (!_myTextView) {
        
        _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
        
        _myTextView.editable = NO;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"VersionText" ofType:@"txt"];
        
        NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        _myTextView.text = string;
    }
    return _myTextView;
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

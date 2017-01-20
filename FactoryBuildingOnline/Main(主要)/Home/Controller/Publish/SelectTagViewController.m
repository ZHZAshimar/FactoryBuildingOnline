//
//  SelectTagViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/19.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SelectTagViewController.h"

@interface SelectTagViewController ()
{
    int selectedCount;
}

/// 空间大
@property (weak, nonatomic) IBOutlet UIButton *spaceLargeBtn;
/// 环境好
@property (weak, nonatomic) IBOutlet UIButton *environmentGoodBtn;
/// 交通便利
@property (weak, nonatomic) IBOutlet UIButton *easyTransportBtn;
/// 楼层多
@property (weak, nonatomic) IBOutlet UIButton *moreFloorBtn;
/// 新建房
@property (weak, nonatomic) IBOutlet UIButton *factoryNewBtn;
/// 原房东
@property (weak, nonatomic) IBOutlet UIButton *landlordBtn;
/// 高质量
@property (weak, nonatomic) IBOutlet UIButton *highQuanlityBtn;

@property (nonatomic, strong) NSArray *tagImageSeletedArr;

@property (nonatomic, strong) NSArray *tagImageUnselectArr;

@property (nonatomic, strong) NSArray *tagStringArr;

@property (nonatomic, strong) NSMutableArray *mSeletedStringArr;    // 已选择的 标签数组

@property (nonatomic, strong) NSMutableArray *mSelectedTagArr;      // 已选择的 标签tag

@end

@implementation SelectTagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadArray];
   
}

- (void)loadArray {
    
    self.tagImageSeletedArr = @[[UIImage imageNamed:@"spaceLarge"],[UIImage imageNamed:@"environmentGood"],[UIImage imageNamed:@"easyTransport"],[UIImage imageNamed:@"moreFloor"],[UIImage imageNamed:@"factoryNew"],[UIImage imageNamed:@"landlord"],[UIImage imageNamed:@"highQuanlity"]];
    
    self.tagImageUnselectArr = @[[UIImage imageNamed:@"spaceLarge_un"],[UIImage imageNamed:@"environmentGood_un"],[UIImage imageNamed:@"easyTransport_un"],[UIImage imageNamed:@"moreFloor_un"],[UIImage imageNamed:@"factoryNew_un"],[UIImage imageNamed:@"landlord_un"],[UIImage imageNamed:@"highQuanlity_un"]];
    
    self.tagStringArr = @[@"空间大",@"环境好",@"交通便利",@"楼层多",@"新建房",@"原房东",@"性价高"];
    
    self.mSeletedStringArr = [NSMutableArray arrayWithArray:self.seletedStringArr];
    
    self.mSelectedTagArr = [NSMutableArray arrayWithArray:self.selectedTagArr];
    
    selectedCount = (int)self.mSelectedTagArr.count;
    
    if (self.mSeletedStringArr.count > 0) {
        for (NSNumber *index in self.mSelectedTagArr) {
            int tag = [index intValue];
            switch (tag + 100) {
                case 100:
                    self.spaceLargeBtn.selected = YES;
                    
                    [self.spaceLargeBtn setImage:self.tagImageSeletedArr[tag] forState:0];
                    break;
                case 101:
                    self.environmentGoodBtn.selected = YES;
                    
                    [self.environmentGoodBtn setImage:self.tagImageSeletedArr[tag] forState:0];
                    break;
                case 102:
                    self.easyTransportBtn.selected = YES;
                    
                    [self.easyTransportBtn setImage:self.tagImageSeletedArr[tag] forState:0];
                    break;
                case 103:
                    self.moreFloorBtn.selected = YES;
                    
                    [self.moreFloorBtn setImage:self.tagImageSeletedArr[tag] forState:0];
                    break;
                case 104:
                    self.factoryNewBtn.selected = YES;
                    
                    [self.factoryNewBtn setImage:self.tagImageSeletedArr[tag] forState:0];
                    break;
                case 105:
                    self.landlordBtn.selected = YES;
                    
                    [self.landlordBtn setImage:self.tagImageSeletedArr[tag] forState:0];
                    break;
                case 106:
                    self.highQuanlityBtn.selected = YES;
                    
                    [self.highQuanlityBtn setImage:self.tagImageSeletedArr[tag] forState:0];
                    break;
                default:
                    break;
            }
            
        }
        [self.mSeletedStringArr removeAllObjects];
    }
    
    NSLog(@"self.mSeletedStringArr :%@--self.mSelectedTagArr %@",self.mSeletedStringArr,self.mSelectedTagArr );

    
}

- (BOOL) isOverCount {
    
    if (selectedCount >= 3) {   // 超过三个的时候则不给予选择，弹出提示框
        
        [MBProgressHUD showError:@"只能选择三个标签" ToView:nil];
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

// 返回按钮
- (IBAction)backBtnAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
// 所有按钮的点击事件
- (IBAction)tagBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    int index = (int)sender.tag - 100;
    
    if (sender.selected) {
        
        if ([self isOverCount]) {
            
            sender.selected = NO;
            
            return;
        }
        
        [sender setImage:self.tagImageSeletedArr[index] forState:0];
        
        [self.mSelectedTagArr addObject:@(index)];
        
        selectedCount++;
        
    } else {
        
        [sender setImage:self.tagImageUnselectArr[index] forState:0];
        
        [self.mSelectedTagArr removeObject:@(index)];
        
        selectedCount--;
    }
    
}

// 点击确定按钮的响应事件
- (IBAction)selectOKAction:(UIButton *)sender {
    
    for (NSNumber *index in self.mSelectedTagArr) {
        
        for (int j = 0; j < self.tagStringArr.count; j++) {
            
            if ([index intValue] == j) {
                [self.mSeletedStringArr addObject:self.tagStringArr[j]];
            }
            
        }
        
    }
    NSLog(@"已选择的标签 ：%@",self.mSeletedStringArr);
    
    self.tagBlock(self.mSeletedStringArr,self.mSelectedTagArr);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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

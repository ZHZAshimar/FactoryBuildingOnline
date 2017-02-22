//
//  UserInfomationViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/3.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "UserInfomationViewController.h"

//#import "UserInfoModel+CoreDataClass.h"
#import "FOLUserInforModel.h"
#import "ChangeNameViewController.h"
#import "ChangePasswordViewController.h"
#import "MeNetRequest.h"
#import "SecurityUtil.h"

@interface UserInfomationViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate>
{
    FOLUserInforModel *userModel;
    UILabel *nameLabel;
    MeNetRequest *meNetRequest; // 我的界面的数据请求类
    UIImagePickerController *imagePickerController;
}
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic)  NSString *userName;  // 用户名称
@property (strong, nonatomic) UIImageView *avatarImageView; // 头像
@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation UserInfomationViewController

- (void)dealloc {
//    self.actionSheet.delegate = nil;
//    imagePickerController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    userModel = [[FOLUserInforModel findAll] firstObject];
    
    [self.myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"个人信息" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
    
    [self.view addSubview:self.myTableView];
    
}
#pragma mark - tableVeiw datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height*11/142;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.textColor = BLACK_42;
    
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"头像";
                [self.avatarImageView removeFromSuperview];
                CGFloat imageHeight = (Screen_Height*11/142)*29/44;
                self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width-15-29, 7.5, imageHeight, imageHeight)];
                
                NSString *avatarURL = [SecurityUtil decodeBase64String:userModel.avatar];
                
                if (userModel.type == 2) {
                    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"my_broker"]];
                } else {
                    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"my_normal"]];
                }
                
                if (avatarURL.length > 0) {
                    
                    self.avatarImageView.layer.borderColor = GRAY_99.CGColor;
                    self.avatarImageView.layer.borderWidth = 0.5;
                    
                    self.avatarImageView.layer.cornerRadius = imageHeight/2;
                    self.avatarImageView.layer.masksToBounds = YES;
                }
                
                [cell addSubview:self.avatarImageView];
                
            } else {
                cell.textLabel.text = @"名称";
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [nameLabel removeFromSuperview];
                
                nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-30-Screen_Width/2, 0, Screen_Width/2, Screen_Height*11/142)];
                
                nameLabel.text = userModel.userName;
                
                nameLabel.textColor = BLACK_42;
                
                nameLabel.textAlignment = NSTextAlignmentRight;
                
                nameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
                
                [cell addSubview:nameLabel];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"绑定账号";
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-15-Screen_Width/2, 0, Screen_Width/2, Screen_Height*11/142)];
                
                label.text = userModel.phoneNum;
                label.textColor = BLACK_42;
                label.textAlignment = NSTextAlignmentRight;
                label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
                [cell addSubview:label];
            } else {
                cell.textLabel.text = @"修改密码";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
            break;
            
        default:
        {
            cell.textLabel.text = @"退出登录";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
    }
    
    return cell;
}
#pragma mark - tableView delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                // 修改头像 进入本地相册
                [self.actionSheet showInView:self.view];
                
                
            } else {
                // 修改名称
                ChangeNameViewController *changeNameVC = [ChangeNameViewController new];
                
                changeNameVC.userName = userModel.userName;
                
//                changeNameVC.block = ^(NSString *userName) {
//                    userName = userName;
//                };
                [self.navigationController pushViewController:changeNameVC animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                // 更改手机号
                
            } else {
                // 修改密码
                ChangePasswordViewController *changePwd = [ChangePasswordViewController new];
                [self.navigationController pushViewController:changePwd animated:YES];
            }
        }
            break;
            
        default:  // 退出登录
        {
            [HTTPREQUEST_SINGLE delectWithQuitLogin:URL_DELECT_QUIT andParameters:nil isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
                
                NSLog(@"用户退出：%@",response);
                
                if ([response[@"erro_code"] intValue] != 200) {
                    return ;
                }
                
                [FOLUserInforModel deleteAll];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(RequestManager *manager, NSError *error) {
                NSLog(@"用户退出：%@",error);
                
            }];
            
        }
            break;
    }
    
}

#pragma mark - actionsheet delegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        } else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
       imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;  // 两个 delegate UIImagePickerControllerDelegate,UINavigationControllerDelegate,
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@",image);
    
    meNetRequest = [MeNetRequest new];
    
    [meNetRequest getImageTokenToPushQN:image];
    
    __weak typeof (self) weakSelf = self;
    
    meNetRequest.avatarBlock = ^(BOOL flag) {
        if (flag) {
            
            userModel = [[FOLUserInforModel findAll] firstObject];
            
            [weakSelf.myTableView reloadData];
        }
    };
}

#pragma mark - lazyload
- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _myTableView.backgroundColor = GRAY_F5;
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.sectionFooterHeight = 10.0f;
        
        [_myTableView setSeparatorColor:GRAY_db];   // 设置分各线的颜色
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _myTableView;
}

- (UIActionSheet *)actionSheet {
    
    if (!_actionSheet) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        } else {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        self.actionSheet.tag = 1000;
    }
    return _actionSheet;
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

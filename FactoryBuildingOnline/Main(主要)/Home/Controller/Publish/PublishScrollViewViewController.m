//
//  PublishScrollViewViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/20.
//  Copyright © 2016年 XFZY. All rights reserved.
//  失败的一个界面，待优化

#import "PublishScrollViewViewController.h"

#import "SelectAreaTableViewController.h"
#import "AdjustTradeTableViewController.h"
#import "ParkMakingTypeTableViewController.h"
#import "SelectTagViewController.h"
#import "SelectAllAreaViewController.h"

#import "TZImagePickerController.h"
#import "PictureCollectViewController.h"
#import "QNConfiguration.h"
#import <QiniuSDK.h>

#import "DescriptViewController.h"
#import "UnitViewController.h"
#import "NSString+Judge.h"

#import "geohash.h"
#import "GeoCodeOfBaiduMap.h"

#import "FOLUserInforModel.h"
#import <IQKeyboardManager.h>
#import "PickerView.h"
#define ImageViewHeight 170
#define ViewHeight 850
@interface PublishScrollViewViewController ()<TZImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    TZImagePickerController *imagePickerVC;
    NSDictionary *publishDic;
    BOOL tapAgainBtn;
    NSArray *tagMArrary;     // 标签的数组
    NSArray *tagIndexArray; // 标签数组对应的按钮tag 值
    NSString *townID_pub;
    NSString *cityID_pub;
    UIButton *officeLastButton;     // officearea最后一个按钮
    UIButton *hostelLastButton;     // hostelarea最后一个按钮
    CGFloat officeAreaStr;        // 办公室面积   按需分配：-1
    CGFloat hostelAreaStr;        // 宿舍面积     按需分配：-1
    UITextField *lastTF;
}
@property (nonatomic, strong) NSMutableArray *imageArray;       // 已选的图片数组
@property (nonatomic, strong) NSMutableArray *imageKeyArr;      // 存放图片名称的数组
@property (nonatomic, strong) NSArray *selectDataArray;         // 选项的数组
@property (nonatomic, strong) UIButton *againTakePhotoBtn;
@property (nonatomic, strong) PickerView *myPickerView;         // 自定义的PickerView
@property (nonatomic, strong) NSMutableArray *postDataArray;    // 上传的数据记载

@property (nonatomic, strong) NSString *adjustStr;
@property (nonatomic, strong) NSString *parkMakingStr;
@property (nonatomic, strong) NSDictionary *areaDict;
@end

@implementation PublishScrollViewViewController

- (void)dealloc {
    imagePickerVC.delegate = nil;
    
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil; // 不用时，置nil
//    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
//    [IQKeyboardManager sharedManager].canGoNext = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.publish_type == WANTED_TYPE) {
        
        [self setVCName:@"发布求租" andShowSearchBar:NO andTintColor:BLACK_42 andBackBtnStr:nil];
    
        self.heightOfImageView.constant = 0;    // 将第一个view的高度 约束设置为0
        self.heightOfView.constant = 810 - ImageViewHeight;   // 将整个view的高度约束缩短第一个view的高度
        
    } else {
        [self setVCName:@"发布招租" andShowSearchBar:NO andTintColor:BLACK_42 andBackBtnStr:nil];
    }
    [self initData];
    [self drawView];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    
}

- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PublishSelect.plist" ofType:nil]; // 获取选择项中的内容
    
    self.selectDataArray = [NSArray arrayWithContentsOfFile:path];
    self.postDataArray = [NSMutableArray array];
    // 先给数组添加数据，在选择器选择之后进行替换
    for (int i = 0; i < 11; i++) {
        [self.postDataArray addObject:@(-1)];
        switch (i) {
            case 0:case 1:case 2:case 3:case 4:case 8:case 9:case 10:
            {
                [self.postDataArray addObject:@(0)];
            }
                break;
            case 6:
            {
                [self.postDataArray addObject:@(1)];
            }
                break;
            default:
                break;
        }
    }
    
    self.areaDict = [NSDictionary dictionary];
}

- (void)drawView {
    self.scrollView.delegate = self;
    publishDic = [NSDictionary dictionary];
    
    self.imageArray = [NSMutableArray array];       // 初始化图片数组
    self.imageKeyArr = [NSMutableArray array];      // 初始化图片KEY数组
    
    self.takeAphotoBtn.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:182.0/255.0 blue:47.0/255.0 alpha:0.7];    // 设置拍照按钮的背景颜色
    self.takeAphotoBtn.layer.masksToBounds = YES;
    self.takeAphotoBtn.layer.cornerRadius = 32;
    
    // 下拉显示的 textfield
    self.rantStyleTF.delegate = self;
    self.rantAndSaleTF.delegate = self;
    self.depositStyleTF.delegate = self;
    self.owerTypeTF.delegate = self;
    self.olderLevelTF.delegate = self;
    self.adjustTradeTF.delegate = self;
    self.onFloorTF.delegate = self;
    self.floorStrucureTF.delegate = self;
    self.factoryCanteenTF.delegate = self;
    self.parkMakingTF.delegate = self;
    self.elevatorTF.delegate = self;
    self.fireControlTF.delegate = self;
    self.enviromentalTF.delegate = self;
    
    // 填写内容的
    
    self.lotTF.delegate = self;
    //    self.factoryAreaTF.delegate = self;
    self.priceTF.delegate = self;
    self.titleTF.delegate = self;
    //    self.linkmanTF.delegate = self;
    self.phoneNumTF.delegate = self;
    self.describeTextView.delegate = self;
    
    self.officeareaTF.delegate = self;
    self.hostelAreaTF.delegate = self;
    self.electricityTF.delegate = self;
    self.floorHeightTF.delegate = self;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGestureAction:)]; // 为 图片 视图添加点击事件
    [self.pictureImageView addGestureRecognizer:tapGesture];
    
    self.publishBtn.enabled = NO;
    self.publishBtn.layer.cornerRadius = 5;
    self.publishBtn.layer.masksToBounds = YES;
    
//    [self getValue];      // 保存按钮的功能
    
    if (self.imageArray.count > 1) {
        
        self.pictureImageView.image = self.imageArray[0];
        
        [self.againTakePhotoBtn setTitle:[NSString stringWithFormat:@"%d/9",self.imageArray.count] forState:UIControlStateNormal];
        
        [self loadFirstView];
        
    } else {
        self.pictureImageView.userInteractionEnabled = NO;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.scrollView endEditing:YES];
}

#pragma mark - 判断是否有保存值
- (void)getValue {

//    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[PublishModel find]];
//    NSLog(@"%@",mArray);
//    
//    if (mArray.count > 0) {
//        
//        PublishModel *publishModel =  mArray[0];
//        
//        if (self.publish_type != publishModel.publish_type) {
//            return;
//        }
//        
//        self.lotTF.text = publishModel.address;
//        
//        self.factoryAreaTF.text = publishModel.range;
//        
//        self.priceTF.text = publishModel.price;
//        
//        self.titleTF.text = publishModel.title;
//        
//        self.linkmanTF.text = publishModel.contact_name;
//        
//        self.phoneNumTF.text = publishModel.contact_num;
//        
//        if (self.publish_type == RENT_TYPE) {
//            
//            self.imageArray = [NSMutableArray arrayWithArray:publishModel.pics];
//            NSLog(@"图片数组:%@",self.imageArray);
//            
//        }
//    }
}

#pragma mark - 键盘将要消失
- (void)hiddenKeyboardAction: (NSNotification *)sender {
    
    if (self.publish_type == WANTED_TYPE) {
        
        self.heightOfView.constant = ViewHeight-ImageViewHeight;
        
    } else {
        
        self.heightOfView.constant = ViewHeight;
        
    }
    
}
#pragma mark - 键盘将要出现
- (void)showKeyboardAction: (NSNotification *)sender {
    
    NSValue *rectValue = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [rectValue CGRectValue].size.height;
    
    if (self.publish_type == WANTED_TYPE) {
        self.heightOfView.constant = ViewHeight - ImageViewHeight + keyboardHeight;
    } else {
        self.heightOfView.constant = ViewHeight + keyboardHeight;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 拍照
- (IBAction)takePhotosAction:(UIButton *)sender {
    
    if (sender.tag == 100) {
        
        imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
        
        tapAgainBtn = NO;
        
    } else {
        
        int shounldSelectImageCount = 9 - (int)self.imageArray.count;
        
        if (shounldSelectImageCount <= 0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"最多只能选择9张图片" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:shounldSelectImageCount columnNumber:3 delegate:self pushPhotoPickerVc:YES];
        tapAgainBtn = YES;
    }
    
    imagePickerVC.sortAscendingByModificationDate = NO;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - 办公室面积
- (IBAction)officeAreaButtonAction:(UIButton *)sender {
    
    [officeLastButton setImage:[UIImage imageNamed:@"publish_unCheck"] forState:0];
    
    if (sender.tag == 100) {
        [sender setImage:[UIImage imageNamed:@"publish_Check"] forState:0];
        officeAreaStr = -1;
    } else {
        [sender setImage:[UIImage imageNamed:@"publish_Check"] forState:0];
        [self.officeareaTF becomeFirstResponder];   // 开启第一响应者
    }
    officeLastButton = sender;
}
#pragma mark - 宿舍面积
- (IBAction)hotelAreaButtonAction:(UIButton *)sender {
    
    [hostelLastButton setImage:[UIImage imageNamed:@"publish_unCheck"] forState:0];
    if (sender.tag == 100) {
        [sender setImage:[UIImage imageNamed:@"publish_Check"] forState:0];
        hostelAreaStr = -1;
    } else {
        [sender setImage:[UIImage imageNamed:@"publish_Check"] forState:0];
        [self.hostelAreaTF becomeFirstResponder];   // 开启第一响应者
    }
    hostelLastButton = sender;
}
#pragma mark - 选择区域
- (IBAction)areaSelectAction:(UIButton *)sender {
    
    SelectAllAreaViewController *selectAreaVC = [SelectAllAreaViewController new];
    
//    selectAreaVC.selectedStr = self.selectAreaBtn.titleLabel.text;
    
    __weak PublishScrollViewViewController *weakSelf = self;
    selectAreaVC.pushDict = self.areaDict;
    selectAreaVC.areaBlock = ^(NSDictionary *dict) {
        
        weakSelf.areaDict = dict;
        [weakSelf.selectAreaBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@",dict[@"province"][0],dict[@"city"][0],dict[@"area"][0]] forState:(UIControlStateNormal)];
//        townID_pub = townID;
//        cityID_pub = cityID;
//        NSLog(@"%@--%@",cityID,townID);
    };
    
    [self.navigationController pushViewController:selectAreaVC animated:YES];
    
}
#pragma mark - 下拉按钮的响应事件
- (IBAction)selectItemAction:(UIButton *)sender {
    
    __weak PublishScrollViewViewController *weakSelf = self;
    
    // 下拉按钮的判断
    if (sender.tag >= 110 && sender.tag < 130) {
        
        NSInteger tagIndex = sender.tag-110;

        self.myPickerView.hidden = NO;
        
        self.myPickerView.dataSource = self.selectDataArray[tagIndex];
        
        self.myPickerView.selectStrBlock = ^(NSString *selectStr,NSInteger index) {
            
            if (index < 1) {
                return ;
            }
            switch (tagIndex) {
                case 0:
                    weakSelf.rantStyleTF.text = selectStr;
                    break;
                case 1:
                    weakSelf.rantAndSaleTF.text = selectStr;
                    break;
                case 2:
                    weakSelf.depositStyleTF.text = selectStr;
                    break;
                case 3:
                    weakSelf.owerTypeTF.text = selectStr;
                    break;
                case 4:
                    weakSelf.olderLevelTF.text = selectStr;
                    break;
                case 5:
                    weakSelf.onFloorTF.text = selectStr;
                    break;
                case 6:
                    weakSelf.floorStrucureTF.text = selectStr;
                    break;
                case 7:
                    weakSelf.factoryCanteenTF.text = selectStr;
                    break;
                case 8:
                    weakSelf.elevatorTF.text = selectStr;
                    break;
                case 9:
                    weakSelf.fireControlTF.text = selectStr;
                    break;
                case 10:
                    weakSelf.enviromentalTF.text = selectStr;
                    break;
                default:
                    break;
            }
            
            [weakSelf.postDataArray replaceObjectAtIndex:tagIndex withObject:@(index-1)];
            
            [weakSelf judgeStringisPublish:NO]; // 判断是否能发布
        };
        
    }
}


#pragma mark - 选择 标签Tag 按钮
- (IBAction)selectTagBtnAction:(UIButton *)sender {
    
    SelectTagViewController *tagVC = [SelectTagViewController new];
    
    tagVC.selectedTagArr = tagIndexArray;
    
    tagVC.seletedStringArr = tagMArrary;
    
    __weak PublishScrollViewViewController *weakSelf = self;
    
    tagVC.tagBlock = ^(NSArray *tagArr, NSArray* tag) {
        
        [weakSelf.selectTapBtn setTitle:@"" forState:UIControlStateNormal]; // 去除 button 上的文字
        NSArray *fontColorArr = @[GREEN_1ab8,BLUE_font,YELLOW_font,PINK_font,PURPLE_font,RED_font,CYAN_font];        // label font 的颜色数组
        NSArray *bgColorArr = @[GREEN_bg,BLUE_bg,YELLOW_bg,PINK_bg,PURPLE_bg,RED_bg,CYAN_bg];                // label background 的颜色数组
        NSMutableArray *widthArr = [NSMutableArray array];                  // 文字的宽度数组  第一个标签的x 为0，第二个标签的x 是上一个标签的文字宽度+间距
        
        // 在绘制 label 之前先 将已有的Label 移除
        for (UILabel *label in [weakSelf.tagView subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                [label removeFromSuperview];
            }
        }
        tagMArrary = nil;
        tagIndexArray = nil;
        
        for (int i = 0; i < tagArr.count; i++) {
            
            NSString *tagStr = tagArr[i];   // 拿到标签文字
            CGFloat width = [NSString widthForString:tagStr fontSize:11.0f andHeight:21]+12;  // 获取string 的宽度
            [widthArr addObject:@(width)];
            
            tagMArrary = [NSArray arrayWithArray:tagArr];
            tagIndexArray = [NSArray arrayWithArray:tag];
            
            CGFloat lastWidth = 0.0;
            if (i == 1) {
                lastWidth = [widthArr[0] floatValue];
            }
            if (i == 2) {
                lastWidth = [widthArr[0] floatValue] + [widthArr[1] floatValue];
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*10+lastWidth, 23/2, width, 21)];
            label.text = tagArr[i];
            label.alpha = .8f;
            label.font = [UIFont systemFontOfSize:11.0f];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
            [weakSelf.tagView addSubview:label];
            // 设置标签的名字
            if ([tagStr isEqualToString:@"空间大"]) {
                
                label.textColor = fontColorArr[0];
                label.backgroundColor = bgColorArr[0];
            } else if ([tagStr isEqualToString:@"楼层多"]) {
                
                label.textColor = fontColorArr[1];
                label.backgroundColor = bgColorArr[1];
            } else if ([tagStr isEqualToString:@"环境好"]) {
                
                label.textColor = fontColorArr[2];
                label.backgroundColor = bgColorArr[2];
            } else if ([tagStr isEqualToString:@"性价高"]) {
                
                label.textColor = fontColorArr[3];
                label.backgroundColor = bgColorArr[3];
            } else if ([tagStr isEqualToString:@"原房东"]) {
                
                label.textColor = fontColorArr[4];
                label.backgroundColor = bgColorArr[4];
            } else if ([tagStr isEqualToString:@"新建房"]) {
                
                label.textColor = fontColorArr[5];
                label.backgroundColor = bgColorArr[5];
            } else {
                
                label.textColor = fontColorArr[6];
                label.backgroundColor = bgColorArr[6];
            }
        }
        [self judgeStringisPublish:NO];
    };
    
    [self presentViewController:tagVC animated:YES completion:^{
        
    }];
}

- (void) judgeStringisPublish:(BOOL) isPublish{
    
    [self setPublishBtnStyle:NO];   // 先让 button 处于不可点击的状态，当判断通过之后再设置为可点击状态
    
    if (self.titleTF.text.length <= 0) return;
    
    if (self.describeTextView.text.length <= 0) return;
    
    if (self.selectAreaBtn.titleLabel.text.length <= 0) return;
    
    if (self.lotTF.text.length <= 0) return;
    
    if (self.factoryAreaTF.text.length <= 0) return;
  

    if (self.priceTF.text.length <= 0)  return;
    
    if (self.linkmanTF.text.length <= 0) return;
    
    if (self.phoneNumTF.text.length <= 0) return;
    
    if (tagMArrary.count <= 0) return;
    
    if (self.parkMakingTF.text.length <= 0) return;

    if (self.adjustTradeTF.text.length <= 0) return;

    if (self.floorHeightTF.text.length <= 0) return;
    
    if (self.moneyRewardTF.text.length <= 0) return;
    
    if (![NSString validatePureNumandCharacters:self.moneyRewardTF.text]) {
        [MBProgressHUD showError:@"请输入纯文字" ToView:nil];
    }
    for (NSString *obj in self.postDataArray) {
        int tagIndex = [obj intValue];
        if (tagIndex < 0) {
            return;
        }
    }
    
    [self setPublishBtnStyle:YES];
    
    if (isPublish) {
        if (self.imageArray.count <= 0) {
            
            [MBProgressHUD showAutoMessage:@"拍个照呗！" ToView:nil];
            
            return;
        }
        
        if (![NSString validateMobile:self.phoneNumTF.text]) {
            
            [MBProgressHUD showAutoMessage:@"请正确输入手机号！" ToView:nil];
            
            return;
        }
        NSString *priceStr = [self.priceTF.text stringByReplacingOccurrencesOfString:@"/月/m²" withString:@""];
        if (![NSString validatePureNumandCharacters:priceStr]) {
            
            [MBProgressHUD showAutoMessage:@"请正确输入价格哦~" ToView:nil];
            
            NSLog(@"%@",self.priceTF.text);
            return;
        }
        
        if (self.describeTextView.text.length <= 0) {
            
            [MBProgressHUD showAutoMessage:@"请输入描述，10个字以上哦~" ToView:nil];
            
            return;
        }
        NSArray *array = [self.selectAreaBtn.titleLabel.text componentsSeparatedByString:@"-"];
        
        //    geo检索信息类
        BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geocodeSearchOption.city= array[0];
        geocodeSearchOption.address = [NSString stringWithFormat:@"%@%@",array[1],self.lotTF.text];
        
        BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
        
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
       
    }

}
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
   
    NSLog(@"%f -- %f",result.location.latitude,result.location.longitude);
    
    NSString*geohashStr = [GeoCodeOfBaiduMap getGeohash:result.location.latitude andLon:result.location.longitude andLength:12];
    
//    NSString *tag = [NSString arrayToJson:tagMArrary];
//    NSString *pics = [NSString arrayToJson:self.imageKeyArr];
    FOLUserInforModel *model = [[FOLUserInforModel findAll] firstObject];
//     publishDic = @{@"tags":tagMArrary,@"user_id":model.userID,@"city_id":cityID_pub,
//                    @"area_id":townID_pub,@"address":self.lotTF.text,
//                    @"price":[self.priceTF.text stringByReplacingOccurrencesOfString:@"/月/m²" withString:@""],
//                    @"range":[self.factoryAreaTF.text stringByReplacingOccurrencesOfString:@"平方米" withString:@""],
//                    @"title":self.titleTF.text,@"rent_type": self.rantStyleTF.text,
//                    @"pre_pay":self.depositStyleTF.text,@"description":self.describeTextView.text,
//                    @"contact_name":self.linkmanTF.text,@"contact_num":self.phoneNumTF.text,
//                    @"pics":self.imageKeyArr,@"geohash":geohashStr
//                    };
    
    
//    NSString *publishStr = [NSString dictionaryToJson:publishDic];
    NSString *tagStr;
    for (NSString *str in tagMArrary) {
        tagStr = [NSString stringWithFormat:@"%@,%@",tagStr,str];
    }
    NSString *imageKeyStr;
    for (NSString *imageKey in self.imageKeyArr) {
        imageKeyStr = [NSString stringWithFormat:@"%@,%@",imageKeyStr,imageKey];
    }
    NSDictionary *dic = @{@"title":self.titleTF.text,@"selling_point":self.describeTextView.text,
                          @"enjoy":self.moneyRewardTF.text,@"total_area":self.factoryAreaTF.text,
                          @"dorm_area":self.hostelAreaTF.text,@"office_area":self.officeareaTF.text,
                          @"contacts":self.linkmanTF.text,@"phone_num":self.phoneNumTF.text,
                          @"price":[self.priceTF.text stringByReplacingOccurrencesOfString:@"/月/m²" withString:@""],
                          @"distribution":self.electricityTF.text,@"floor_hight":self.floorHeightTF.text,
                          @"trade_id":self.adjustStr,@"facilities":self.parkMakingStr,
                          @"tags":tagStr,@"thumbnails":imageKeyStr,
                          @"address":self.lotTF.text,@"area_code":self.areaDict[@"area"][2],
                          @"dorm_area":@(hostelAreaStr),@"office_area":@(officeAreaStr),
                          @"rent_type_id":self.postDataArray[0],@"rent_mode_id":self.postDataArray[1],
                          @"foregift_id":self.postDataArray[2],@"owner_type_id":self.postDataArray[3],
                          @"newold_id":self.postDataArray[4],@"floor_pos_id":self.postDataArray[5],
                          @"struct_id":self.postDataArray[6],@"canteen":self.postDataArray[7],
                        @"is_elevator":self.postDataArray[8],@"is_fire_protection":self.postDataArray[9],
                          @"green_card":self.postDataArray[10]};
    
    [HTTPREQUEST_SINGLE postRequestWithService:@"apps/factory/issuance/" andParameters:dic isShowActivity:YES dicIsEncode:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"发布：%@",response);
        if ([response[@"erro_code"] intValue] != 200) [MBProgressHUD showSuccess:@"发布失败" ToView:nil];
        else [MBProgressHUD showSuccess:@"发布成功" ToView:nil];
        
        
//        [self.navigationController popViewControllerAnimated:YES];
        
//        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"error:%@",error.debugDescription);
        [MBProgressHUD showError:@"似乎与网络已断开连接" ToView:nil];
    }];
    
    if (publishDic.count > 0) {
        
//        [PublishModel deleteAll];
        
    }

}
- (void)setPublishBtnStyle:(BOOL)isEnable {
    
    if (isEnable) {
        
        self.publishBtn.enabled = YES;          // hhll
        self.publishBtn.backgroundColor = GREEN_1ab8;
        [self.publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } else {
        
        self.publishBtn.enabled = NO;          // hhll
        self.publishBtn.backgroundColor = GRAY_db;
        [self.publishBtn setTitleColor:GRAY_99 forState:UIControlStateNormal];
        
    }
}

#pragma mark - 保存按钮 -- 暂时未开通
- (IBAction)saveBtnAction:(UIButton *)sender {
    
////    [self judgeString];
//    
//    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[PublishModel find]];
//    
//    if (mArray.count > 0) {
//         
//        [PublishModel deleteAll];
//    }
//    
//    [PublishModel insertPublishModel:publishDic];
//    
}
#pragma mark - 适用行业
- (IBAction)jumpAdjustVC:(UIButton *)sender {
    
    __weak PublishScrollViewViewController *weakSelf = self;
    // 跳转到选择适用行业
    AdjustTradeTableViewController *adjustVC = [AdjustTradeTableViewController new];
    
    adjustVC.adjustStr = self.adjustTradeTF.text;
    
    adjustVC.adjustTypeBlock = ^(NSString *depositType, NSString *indexStr) {
        
        weakSelf.adjustTradeTF.text = depositType;
        weakSelf.adjustStr = indexStr;
        [self judgeStringisPublish:NO];
    };
    [self.navigationController pushViewController:adjustVC animated:YES];
    
}
#pragma mark - 园区配套
- (IBAction)parkMakingAction:(UIButton *)sender {
    
    __weak PublishScrollViewViewController *weakSelf = self;
    // 跳转到选择适用行业
    ParkMakingTypeTableViewController *adjustVC = [ParkMakingTypeTableViewController new];
    
    adjustVC.parkTypeStr = self.parkMakingTF.text;
    
    adjustVC.parkTypeBlock = ^(NSString *depositType, NSString *indexStr) {
        
        weakSelf.parkMakingTF.text = depositType;
        weakSelf.parkMakingStr = indexStr;
        [self judgeStringisPublish:NO];
    };
    [self.navigationController pushViewController:adjustVC animated:YES];
}

#pragma mark - 发布按钮
- (IBAction)publishBtnAction:(UIButton *)sender {
    
    [self judgeStringisPublish:YES];
    
}
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //    textField.layer.borderColor = NaviBackColor.CGColor;
    //    textField.layer.borderWidth = 1;
    [self setPublishBtnStyle:NO];   // 设置发布按钮的样式
    
    NSLog(@"1111");
    if (textField.tag == 102 && self.factoryAreaTF.text.length > 0){
        
        NSString *string = [self.factoryAreaTF.text stringByReplacingOccurrencesOfString:@"平方米" withString:@""];
        self.factoryAreaTF.text = string;
        
    }
    if (textField.tag == 103 && self.priceTF.text.length > 0){
        
        NSString *string = [self.priceTF.text stringByReplacingOccurrencesOfString:@"/月/m²" withString:@""];
        self.priceTF.text = string;
    }
    lastTF = textField;
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [textField resignFirstResponder];
    
    if (textField.tag >= 200 && textField.tag < 250) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    NSLog(@"编辑结束");
    [textField resignFirstResponder];
//    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    
    if (textField == self.factoryAreaTF && self.factoryAreaTF.text.length > 0) {
        self.factoryAreaTF.text = [NSString stringWithFormat:@"%@%@",self.factoryAreaTF.text,@"平方米"];
    }
    if (textField == self.priceTF && self.priceTF.text.length > 0){
        
        self.priceTF.text = [NSString stringWithFormat:@"%@%@",self.priceTF.text,@"/月/m²"];
    }
    [self judgeStringisPublish:NO];     // 编辑结束之后 走判断 方法
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self judgeStringisPublish:NO];
    
    if (textField == self.hostelAreaTF) {
        hostelAreaStr = [self.hostelAreaTF.text floatValue];
    } else if (textField == self.officeareaTF){
        officeAreaStr = [self.officeareaTF.text floatValue];
    }
    
    [textField resignFirstResponder];
//    [self.lotTF resignFirstResponder];
//    [self.priceTF resignFirstResponder];
//    [self.titleTF resignFirstResponder];
//    [self.linkmanTF resignFirstResponder];
//    [self.phoneNumTF resignFirstResponder];
    return YES;
}

#pragma mark - textView delegate - 
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {     // 判断是否显示 提示 label
        self.describeLabel.hidden = YES;
    } else {
        self.describeLabel.hidden = NO;
    }
}
#pragma mark - TZImagePickerController delegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSLog(@"完成");
    
    PictureCollectViewController *pictureVC = [[PictureCollectViewController alloc] init];
    
    [self.navigationController pushViewController:pictureVC animated:YES];
    
    pictureVC.showImageCount = 3;   // 视图横向显示图片的个数
    
    if (tapAgainBtn) {  // 从小按钮进入
        
        pictureVC.photos = self.imageArray;
        pictureVC.imageKeyArr = self.imageKeyArr;
        
        pictureVC.littleBtnPhotos = photos;
        
    } else {
        
        pictureVC.uploadQiniu = YES;
        
        pictureVC.photos = photos;      // 将拿到的图片数据 传给 图片
        
        NSLog(@"点击完成选中的图片 %@",pictureVC.photos);
    }
    __weak typeof (self) weakSelf = self;
    
    pictureVC.photosArr = ^(NSMutableArray *photosArray,NSMutableArray *keyArray) {  // 点击确定按钮 回调 图片
        
        NSLog(@"%@",photosArray);
        weakSelf.pictureImageView.contentMode = UIViewContentModeScaleAspectFit;
        weakSelf.pictureImageView.image = photosArray[0];   // 更新 第一个view的图片
        
        [weakSelf.againTakePhotoBtn setTitle:[NSString stringWithFormat:@"%d/9",photosArray.count] forState:UIControlStateNormal];
        
        [weakSelf.imageArray removeAllObjects];
        
        for (UIImage *obj in photosArray) {
            
            [weakSelf.imageArray addObject: obj];   // 将图片数组赋值给  self.imageArray
        }
        
        [weakSelf.imageKeyArr removeAllObjects];
        
        for (NSString *key in keyArray) {
            [weakSelf.imageKeyArr addObject:key];
        }
        
        
        [weakSelf loadFirstView];
    };
}

- (void)tapImageGestureAction: (UITapGestureRecognizer *)sender {
    
    PictureCollectViewController *pictureVC = [[PictureCollectViewController alloc] init];
    
    pictureVC.showImageCount = 3;
    
    pictureVC.uploadQiniu = NO;
    
    pictureVC.photos = self.imageArray;
    
    pictureVC.imageKeyArr = self.imageKeyArr;
    
    [self.navigationController pushViewController:pictureVC animated:YES];
    
    __weak typeof (self) weakSelf = self;
    // 回调传回 图片
    pictureVC.photosArr = ^(NSMutableArray *photosArray,NSMutableArray *keyArray) {
        
        weakSelf.pictureImageView.image = photosArray[0];   // 更新 第一个view的图片
        
        [weakSelf.againTakePhotoBtn setTitle:[NSString stringWithFormat:@"%d/9",photosArray.count] forState:UIControlStateNormal];
        
        [weakSelf.imageArray removeAllObjects];
        
        for (UIImage *obj in photosArray) {
            
            [weakSelf.imageArray addObject: obj];   // 将图片数组赋值给  self.imageArray
        }
        
        [weakSelf.imageKeyArr removeAllObjects];
        
        for (NSString *key in keyArray) {
            [weakSelf.imageKeyArr addObject:key];
        }
        
        [weakSelf loadFirstView];
    };
    
}

- (void)loadFirstView {
        
    self.takeAphotoBtn.hidden = YES;
    self.takePhotoLabel.hidden = YES;
    
    self.pictureImageView.userInteractionEnabled = YES;
    
    self.againTakePhotoBtn.hidden = NO;
}

#pragma mark - 点击屏幕，注销第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self judgeStringisPublish:NO];
    [self.factoryAreaTF resignFirstResponder];
    [self.lotTF resignFirstResponder];
    [self.priceTF resignFirstResponder];
    [self.titleTF resignFirstResponder];
    [self.linkmanTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
}

#pragma mark - lazy load
- (UIButton *)againTakePhotoBtn {
    
    if (!_againTakePhotoBtn) {
        _againTakePhotoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _againTakePhotoBtn.frame = CGRectMake(Screen_Width - 44, ImageViewHeight -44, 44, 44);
        
        _againTakePhotoBtn.tag = 101;
        _againTakePhotoBtn.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:182.0/255.0 blue:47.0/255.0 alpha:0.7]; ;
        _againTakePhotoBtn.layer.masksToBounds = YES;
        _againTakePhotoBtn.layer.cornerRadius = 22;
        [_againTakePhotoBtn setTintColor:[UIColor whiteColor]];
        [_againTakePhotoBtn setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [_againTakePhotoBtn setTitle:@"0/9" forState:UIControlStateNormal];
        _againTakePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        _againTakePhotoBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 10, 0, 0);
        _againTakePhotoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -19, -19, 0);
        _againTakePhotoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_againTakePhotoBtn addTarget:self action:@selector(takePhotosAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageBGView addSubview:_againTakePhotoBtn];
        NSLog(@"firstView height %f",self.imageBGView.frame.size.height);
    }
    
    return _againTakePhotoBtn;
}

- (PickerView *)myPickerView {
    if (!_myPickerView ) {
        _myPickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, Screen_Height-Screen_Height*206/568, Screen_Width, 206)];
        _myPickerView.hidden = YES;
        [self.view bringSubviewToFront:_myPickerView];
        [self.view addSubview:_myPickerView];
    }
    return _myPickerView;
}

@end

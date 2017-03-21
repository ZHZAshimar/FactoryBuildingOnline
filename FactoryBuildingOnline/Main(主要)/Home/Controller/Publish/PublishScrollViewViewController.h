//
//  PublishScrollViewViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/20.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
/*
 *  发布类型
 */
typedef enum NSInteger{
    WANTED_TYPE,    // 求租
    RENT_TYPE,       // 出租
}PUBLISH_TYPE;

@interface PublishScrollViewViewController : BaseViewController <BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch* _geocodesearch;
}
@property (nonatomic, assign) PUBLISH_TYPE publish_type;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *takeAphotoBtn;   // 拍照按钮
@property (weak, nonatomic) IBOutlet UILabel *takePhotoLabel;   // 拍照label


@property (weak, nonatomic) IBOutlet UILabel *describeLabel;    // 描述的label
@property (weak, nonatomic) IBOutlet UITextField *titleTF;      // 标题
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;   // 描述
@property (weak, nonatomic) IBOutlet UIButton *selectAreaBtn;    // 区域
@property (weak, nonatomic) IBOutlet UITextField *lotTF;        // 地段

@property (weak, nonatomic) IBOutlet UITextField *factoryAreaTF;// 工厂面积
@property (weak, nonatomic) IBOutlet UITextField *priceTF;      // 价格

@property (weak, nonatomic) IBOutlet UITextField *linkmanTF;    // 联系人
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;   // 手机号
@property (weak, nonatomic) IBOutlet UITextField *identifyTF;   // 身份
@property (weak, nonatomic) IBOutlet UIView *tagView;           // 标签
@property (weak, nonatomic) IBOutlet UIButton *selectTapBtn;

@property (weak, nonatomic) IBOutlet UITextField *depositStyleTF;   // 押金方式
@property (weak, nonatomic) IBOutlet UITextField *rantStyleTF;

@property (weak, nonatomic) IBOutlet UIButton *publishBtn;       // 发布按钮

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;         // 保存按钮

@property (weak, nonatomic) IBOutlet UIView *imageBGView;       // 图片的背景view

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfView;      // 整个View 的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfImageView; // ImageView 的高度约束
@property (weak, nonatomic) IBOutlet UITextField *officeareaTF; // 办公室面积
@property (weak, nonatomic) IBOutlet UITextField *hostelAreaTF; // 宿舍面积
@property (weak, nonatomic) IBOutlet UITextField *rantAndSaleTF;    // 租售方式
@property (weak, nonatomic) IBOutlet UITextField *rantTF;   // 出租方式
@property (weak, nonatomic) IBOutlet UITextField *owerTypeTF;

@property (weak, nonatomic) IBOutlet UITextField *olderLevelTF;

@property (weak, nonatomic) IBOutlet UITextField *adjustTradeTF;
@property (weak, nonatomic) IBOutlet UITextField *electricityTF;
@property (weak, nonatomic) IBOutlet UITextField *onFloorTF;
@property (weak, nonatomic) IBOutlet UITextField *floorStrucureTF;
@property (weak, nonatomic) IBOutlet UITextField *factoryCanteenTF;
@property (weak, nonatomic) IBOutlet UITextField *parkMakingTF;

@property (weak, nonatomic) IBOutlet UITextField *elevatorTF;
@property (weak, nonatomic) IBOutlet UITextField *fireControlTF;

@property (weak, nonatomic) IBOutlet UITextField *floorHeightTF;




@end

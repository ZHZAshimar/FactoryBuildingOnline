//
//  BaseViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UIButton *barButton;
@property (nonatomic, strong) UISearchBar *searchBarOfNavi;
@property (nonatomic, strong) UIBarButtonItem *rightImageItemButton;    // 右边单一个图片按钮
@property (nonatomic, strong) UIButton *leftNaviButton;         // 返回按钮

- (void)addLeftItem:(NSString *)itemName;   // 导航栏 左边文字按钮 一个

- (void)leftItemButtonAction;   // 导航栏 左边按钮点击方法

/**
 *  navigation 添加 单个 右边图片按钮
 *
 *  @param itemName   文字
 *  @param tintColor  前景色
 */
- (void)addRightItemWithString:(NSString *)itemName andItemTintColor:(UIColor *)tintColor;
/**
 *  navigation 添加 单个 右边图片按钮
 *
 *  @param image  图片
 *  @param color  前景色
 */
- (void)addRightItemWithLogo:(UIImage *)image andItemTintColor:(UIColor *)color;
/**
 *  navigation 添加 右边 n个 图片 按钮
 *
 *  @param imageArray    图片数组
 *  @param count 个数
 */
- (void)addRightImageItem:(NSArray *)imageArray buttonCount:(int)count; // 导航栏右端 的图片按钮 多个

/**
 *  navigation 添加 单个 右边 图片+文字 按钮
 *
 *  @param image    图片
 *  @param itemName 文字
 */
- (void)addRightItemCustomWithLogo:(UIImage *)image andItemName:(NSString *)itemName;

/*
 *  一个按钮或第一个按钮的点击事件
 */
- (void)rightItemButtonAction;  // 一个按钮或第一个按钮的点击事件

- (void)rightActionSecond:(UIButton *)sender;   // 第二个按钮的点击事件

- (void)setVCName:(NSString *)vcName andShowSearchBar:(BOOL)showSearchBar andTintColor:(UIColor*)tintColor andBackBtnStr:(NSString *)backStr;    // 设置导航栏标题 判断是否为主页

- (void)backAction;  // 返回按钮


- (void)navigationAddTapGesture;    // 导航栏添加双击手势

- (void)tapGestureAction:(UITapGestureRecognizer *)sender;  // 双击手势响应方法

@end

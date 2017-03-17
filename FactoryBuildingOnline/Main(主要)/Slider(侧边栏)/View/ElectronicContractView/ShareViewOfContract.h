//
//  ShareViewOfContract.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewOfContract : UIView
@property (nonatomic, strong) NSDictionary *shareDic;
/*
 * 显示
 */
- (void)show ;

/*
 *  清除
 */
-(void)dismiss;
@end

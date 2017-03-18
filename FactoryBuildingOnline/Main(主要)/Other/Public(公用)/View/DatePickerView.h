//
//  DatePickerView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SELECTTimeBLOCK)(NSDate *date) ;

@interface DatePickerView : UIView

@property (nonatomic, copy) SELECTTimeBLOCK timeBlock;

@end

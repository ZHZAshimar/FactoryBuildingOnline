//
//  ECWriteHouseContractViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    FactoryBussiness_contract,
    Labour_contract,
    Fitment_contract,
    HouseRent_contract,
    
}CONTRACTTYPE;

@interface ECWriteContractViewController : UIViewController
@property (nonatomic, assign) CONTRACTTYPE contractType;
@end

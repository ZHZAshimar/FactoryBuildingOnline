//
//  BrancheModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrancheModel : NSObject

@property (nonatomic, assign) NSInteger branchID;
@property (nonatomic, strong) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  插入数据库
 *
 *  @prama BrancheModel model
 *  @return BOOL
 */
+ (BOOL)insertWithBranchModel:(BrancheModel *)model;

/**
 *  查找 表中的所有数据
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)findAll;
@end

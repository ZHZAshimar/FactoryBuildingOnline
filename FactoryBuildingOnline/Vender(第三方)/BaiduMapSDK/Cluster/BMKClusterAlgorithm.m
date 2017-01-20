//
//  BMKClusterAlgorithm.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 15/9/15.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "BMKClusterAlgorithm.h"

#define MAX_DISTANCE_IN_DP    200 //300dp

@implementation BMKClusterAlgorithm

@synthesize quadItems = _quadItems;
@synthesize quadtree = _quadtree;

- (id)init {
    self = [super init];
    if (self) {
        _quadtree = [[BMKClusterQuadtree alloc] initWithRect:CGRectMake(0, 0, 1, 1)];
        _quadItems = [[NSMutableArray alloc] init];
    }
    return self;
}

///添加item
- (void)addItem:(BMKClusterItem*)clusterItem {
    BMKQuadItem *quadItem = [[BMKQuadItem alloc] init];
    quadItem.clusterItem = clusterItem;
    @synchronized(_quadtree) {
        [_quadItems addObject:quadItem];
        [_quadtree addItem:quadItem];
//        NSLog(@"%@", _quadtree.quadItems);
    }
}

///清除items
- (void)clearItems {
    @synchronized(_quadtree) {
        [_quadItems removeAllObjects];
        [_quadtree clearItems];
    }
    
}

/**
 *  cluster算法核心
 * @param zoomLevel map的级别
 * @return BMKCluster数组
 */
- (NSArray*)getClusters:(CGFloat) zoomLevel {
    if (zoomLevel < 3 || zoomLevel > 22) {
        return nil;
    }
    NSMutableArray *results = [NSMutableArray array];
    
    NSUInteger zoom = (NSUInteger)zoomLevel;
    CGFloat zoomSpecificSpan = MAX_DISTANCE_IN_DP / pow(2, zoom) / 256;
    NSMutableSet *visitedCandidates = [NSMutableSet set];
    NSMutableDictionary *distanceToCluster = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemToCluster = [NSMutableDictionary dictionary];
    
    @synchronized(_quadtree) {
        for (BMKQuadItem *candidate in _quadItems) {
            //candidate已经添加到另一cluster中
            if ([visitedCandidates containsObject:candidate]) {
                continue;
            }
            BMKCluster *cluster = [[BMKCluster alloc] init];    // 聚合后的标注
            cluster.coordinate = candidate.clusterItem.coor;    // 获取点
            // 获取点对应的范围
            CGRect searchRect = [self getRectWithPt:candidate.pt Span:zoomSpecificSpan];
            // 获取rect范围内的BMKQuadItem
            NSMutableArray *items = (NSMutableArray*)[_quadtree searchInRect:searchRect];
            if (items.count == 1) {
                [cluster.clusterItems addObject:candidate.clusterItem];
                [results addObject:cluster];
                [visitedCandidates addObject:candidate];
                [distanceToCluster setObject:[NSNumber numberWithDouble:0] forKey:[NSNumber numberWithLongLong:candidate.hash]];
                continue;
            }
            
            for (BMKQuadItem *quadItem in items) {
                NSNumber *existDistache = [distanceToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
                CGFloat distance = [self getDistanceSquared:candidate.pt point:quadItem.pt];
                if (existDistache != nil) {
                    if (existDistache.doubleValue < distance) {
                        continue;
                    }
                    BMKCluster *existCluster = [itemToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
                    [existCluster.clusterItems removeObject:quadItem.clusterItem];
                }
                [distanceToCluster setObject:[NSNumber numberWithDouble:distance] forKey:[NSNumber numberWithLongLong:quadItem.hash]];
                [cluster.clusterItems addObject:quadItem.clusterItem];
                [itemToCluster setObject:cluster forKey:[NSNumber numberWithLongLong:quadItem.hash]];
            }
            [visitedCandidates addObjectsFromArray:items];
            [results addObject:cluster];
        }
    }
    return results;
}

/**
 *  cluster算法核心   简单的model
 * @param zoomLevel map的级别
 * @return BMKCluster数组
 */
- (NSArray*)getClustersOfID:(CGFloat) zoomLevel {
    if (zoomLevel < 3 || zoomLevel > 22) {
        return nil;
    }
    
    NSMutableArray *results = [NSMutableArray array];
    
    NSMutableSet *visitedCandidates = [NSMutableSet set];
//    NSMutableDictionary *itemToCluster = [NSMutableDictionary dictionary];
    
    @synchronized(_quadtree) {
        
        for (int i = 0; i < _quadItems.count; i++) {
            
            BMKQuadItem *candidate = _quadItems[i];
            //            NSLog(@"%d",candidate.clusterItem.factoryPoiModel.factory_id);
            //candidate已经添加到另一cluster中
            if ([visitedCandidates containsObject:candidate]) {
                continue;
            }
            BMKCluster *cluster = [[BMKCluster alloc] init];    // 聚合后的标注
            cluster.coordinate = candidate.clusterItem.coor;    // 获取点
            if (zoomLevel >0 ) { // 显示 镇 点聚合
                
                [cluster.clusterItems addObject:candidate.clusterItem];
                cluster.clusterMapPoiModel = candidate.clusterItem.mapPoiModel;
                [results addObject:cluster];
                [visitedCandidates addObject:candidate];
                //                [distanceToCluster setObject:[NSNumber numberWithDouble:0] forKey:[NSNumber numberWithLongLong:candidate.hash]];
                continue;
            }
        }
        
    }
    
    return results;
}

///**
// *  cluster算法核心
// * @param zoomLevel map的级别
// * @return BMKCluster数组
// */
//- (NSArray*)getClustersOfID:(CGFloat) zoomLevel {
//    if (zoomLevel < 3 || zoomLevel > 22) {
//        return nil;
//    }
//    
//    NSMutableArray *results = [NSMutableArray array];
//    
//    NSMutableSet *visitedCandidates = [NSMutableSet set];
//    NSMutableDictionary *itemToCluster = [NSMutableDictionary dictionary];
//    
//    @synchronized(_quadtree) {
//        
//        for (int i = 0; i < _quadItems.count; i++) {
//            
//            BMKQuadItem *candidate = _quadItems[i];
////            NSLog(@"%d",candidate.clusterItem.factoryPoiModel.factory_id);
//            //candidate已经添加到另一cluster中
//            if ([visitedCandidates containsObject:candidate]) {
//                continue;
//            }
//            BMKCluster *cluster = [[BMKCluster alloc] init];    // 聚合后的标注
//            cluster.coordinate = candidate.clusterItem.coor;    // 获取点
//            if (zoomLevel < 7) {
//                
//                for (BMKQuadItem *quadItem in _quadItems) {
//                    
//                    if (candidate.clusterItem.factoryPoiModel.province_id == quadItem.clusterItem.factoryPoiModel.province_id) {
//                        
//                        cluster.clusterFactoryPoiModel = quadItem.clusterItem.factoryPoiModel;
//                        [cluster.clusterItems addObject:quadItem.clusterItem];
//                        [itemToCluster setObject:cluster forKey:[NSNumber numberWithLongLong:quadItem.hash]];
//                        
//                    } else {
//                        
////                        BMKCluster *existCluster = [itemToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
////                        [existCluster.clusterItems removeObject:quadItem.clusterItem];
//                        
//                        continue;
//                    }
//                    [visitedCandidates addObject:quadItem];
//                }
//                
//                [results addObject:cluster];
//                
//            }else if (zoomLevel >= 7 && zoomLevel < 11) {           // 市的级别
//            
//                for (BMKQuadItem *quadItem in _quadItems) {
//                    
//                    if (candidate.clusterItem.factoryPoiModel.city_id == quadItem.clusterItem.factoryPoiModel.city_id) {
//                        
//                        cluster.clusterFactoryPoiModel = quadItem.clusterItem.factoryPoiModel;
//                        [cluster.clusterItems addObject:quadItem.clusterItem];
//                        [itemToCluster setObject:cluster forKey:[NSNumber numberWithLongLong:quadItem.hash]];
//                    } else {
//                        
////                        BMKCluster *existCluster = [itemToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
////                        [existCluster.clusterItems removeObject:quadItem.clusterItem];
//                        continue;
//                    }
//                    
//                    [visitedCandidates addObject:quadItem];
//                }
//                
//                [results addObject:cluster];
//                
//            }else if (zoomLevel >= 11 && zoomLevel < 15) { // 显示 镇 点聚合
//                
//                for (BMKQuadItem *quadItem in _quadItems) {
//                    
//                    if (candidate.clusterItem.factoryPoiModel.district_id == quadItem.clusterItem.factoryPoiModel.district_id) {
//                        
//                        cluster.clusterFactoryPoiModel = quadItem.clusterItem.factoryPoiModel;
//                        [cluster.clusterItems addObject:quadItem.clusterItem];
//                        [itemToCluster setObject:cluster forKey:[NSNumber numberWithLongLong:quadItem.hash]];
//                    } else {
//                        
////                        BMKCluster *existCluster = [itemToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
////                        [existCluster.clusterItems removeObject:quadItem.clusterItem];
//                        continue;
//                    }
//                    
//                    [visitedCandidates addObject:quadItem];
//                   
//                }
//                
//                [results addObject:cluster];
//                
//            } else if (zoomLevel >= 15 /*&& zoomLevel < 15*/) { // 显示 街道 点聚合
//             
//                
//                for (BMKQuadItem *quadItem in _quadItems) {
//                    
//                    if (candidate.clusterItem.factoryPoiModel.street_id == quadItem.clusterItem.factoryPoiModel.street_id) {
//                        
//                        cluster.clusterFactoryPoiModel = quadItem.clusterItem.factoryPoiModel;
//                        [cluster.clusterItems addObject:quadItem.clusterItem];
//                        [itemToCluster setObject:cluster forKey:[NSNumber numberWithLongLong:quadItem.hash]];
//                        
//                    } else {
//                        
////                        BMKCluster *existCluster = [itemToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
////                        [existCluster.clusterItems removeObject:quadItem.clusterItem];
//                        continue;
//                    }
//                    
//                    [visitedCandidates addObject:quadItem];
//                }
//                [results addObject:cluster];
//                               
////            } else if (zoomLevel >= 15) {   // 显示小地点 点聚合
////            
////                [cluster.clusterItems addObject:candidate.clusterItem];
////                cluster.clusterFactoryPoiModel = candidate.clusterItem.factoryPoiModel;
////                [results addObject:cluster];
////                [visitedCandidates addObject:candidate];
////                [distanceToCluster setObject:[NSNumber numberWithDouble:0] forKey:[NSNumber numberWithLongLong:candidate.hash]];
////                continue;
//            }
//        
//////            [results addObject:cluster];
//        }
//        
//    }
//
//    return results;
//}

- (CGRect)getRectWithPt:(CGPoint) pt  Span:(CGFloat) span {
    CGFloat half = span / 2.f;
    return CGRectMake(pt.x - half, pt.y - half, span, span);
}

// 两点间的距离
- (CGFloat)getDistanceSquared:(CGPoint) pt1 point:(CGPoint) pt2 {
    return (pt1.x - pt2.x) * (pt1.x - pt2.x) + (pt1.y - pt2.y) * (pt1.y - pt2.y);
}

@end

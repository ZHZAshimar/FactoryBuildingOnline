//
//  CustomDefine.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#ifndef CustomDefine_h
#define CustomDefine_h

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height

#define NaviHeight 64
#define NaviBackColor [UIColor whiteColor]  // [UIColor colorWithRed:137.0/255.0 green:217.0/255.0 blue:82.0/255.0 alpha:1.0]

#define LightNaviBackColor [UIColor colorWithRed:137.0/255.0 green:217.0/255.0 blue:82.0/255.0 alpha:0.2]

#define GRAY_206 [UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0]
#define GRAY_201 [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0]
#define GRAY_198 [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0]
#define GRAY_106 [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0]
#define GRAY_LIGHT [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]
#define GRAY_80  [UIColor colorWithHex:0x808080]
#define GRAY_F5  [UIColor colorWithHex:0xf5f5f5]
#define GRAY_9e  [UIColor colorWithHex:0x9e9e9e]
#define GRAY_e6  [UIColor colorWithHex:0xe6e6e6]
#define GRAY_9d9c  [UIColor colorWithHex:0x9d9ca2]
#define GRAY_f4 [UIColor colorWithHex:0xf4f4f7]
#define GRAY_eb [UIColor colorWithHex:0xebebeb]
#define GRAY_cc [UIColor colorWithHex:0xcccccc]
#define GRAY_db [UIColor colorWithHex:0xdbdbdb]
#define GRAY_d2 [UIColor colorWithHex:0xd2d2d2]
#define GRAY_235 [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]
#define GRAY_da [UIColor colorWithHex:0xdadada]
#define GRAY_99 [UIColor colorWithHex:0x999999]
#define GRAY_94 [UIColor colorWithHex:0x949494]

#define BLACK_42 [UIColor colorWithHex:0x424242]
#define BLACK_80 [UIColor colorWithHex:0x808080]
#define BLACK_57 [UIColor colorWithHex:0x575757]
#define BLACK_4c [UIColor colorWithHex:0x4c4c4c]
#define BLACK_1a [UIColor colorWithHex:0x1a1a1a]
#define BLACK_138a [UIColor colorWithHex:0x138a5b]

#define GREEN_1ab8 [UIColor colorWithHex:0x1ab80f]
#define GREEN_bg   [UIColor colorWithHex:0xbaf1b7]
#define GREEN_19b8 [UIColor colorWithHex:0x19b80e]

#define RED_COLOR [UIColor colorWithRed:204.0/255.0 green:64/255.0 blue:73.0/255.0 alpha:1.0]
#define RED_df3d [UIColor colorWithHex:0xdf3d3f]
#define RED_ec52 [UIColor colorWithHex:0xec5252]

#define BLUE_bg   [UIColor colorWithHex:0xc3e3fa]
#define BLUE_font [UIColor colorWithHex:0x3c97f0]
#define BLUE_5ca6 [UIColor colorWithHex:0x5ca6ed]

#define YELLOW_bg [UIColor colorWithHex:0xf7f79c]
#define YELLOW_font [UIColor colorWithHex:0xedba1d]

#define PINK_bg [UIColor colorWithHex:0xf9c4e7]
#define PINK_font [UIColor colorWithHex:0xF756C0]

#define PURPLE_bg [UIColor colorWithHex:0xd7b8f7]
#define PURPLE_font [UIColor colorWithHex:0x9636f0]

#define RED_bg [UIColor colorWithHex:0xfeaeb4]
#define RED_font [UIColor colorWithHex:0xcf3a49]

#define CYAN_bg [UIColor colorWithHex:0xa2f2ea]
#define CYAN_font [UIColor colorWithHex:0x16b8ac]

#define PULL_REFRESH_TEXT @"正在玩命加载..."

#define FRESH_OVER_TEXT @"已无数据"

#define RegisterPWDFlagKey @"RegisterPWDFlagKey"
#define UserKey @"UserKey"
#define UserPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.txt"]

#define BaiduMapKey @"1HrdffOWqBOYwdae2VUsNMzajPTOlHMO"

#define HTTPREQUEST_SINGLE [RequestManager shareInstance]

#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"loading"]      // 图片为加载出来时的图片

#endif /* CustomDefine_h */

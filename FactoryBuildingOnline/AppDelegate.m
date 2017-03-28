//
//  AppDelegate.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/29.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "BaseTabBarViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "UMMobClick/MobClick.h"

#define appleID @"1193420004"

#define weiboAppKEY @"769036763"
#define weiboSecret @"0f771400a235cfa1672e0186cd060655"
#define weiboURL @"https://api.weibo.com/oauth2/default.html"

#define QQAppID @"1105941582"
#define QQKey @"6O6L3HFj7sxDSXCX"

#define WXAppID @"wx9d0844d59f7344f3"
#define WXSecret @"aa7a31ff1ee416e6c7d1cd33aa46b5a5"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//#import <AliHotFix/AliHotFix.h>

#import <IQKeyboardManager.h>
#import "PublishScrollViewViewController.h"
@interface AppDelegate ()<RDVTabBarControllerDelegate>
{
    BMKMapManager *_mapManager;
    BaseTabBarViewController *tabBarVC;
}
@end

@implementation AppDelegate
- (void)dealloc {
    
    [self removeObserver:tabBarVC forKeyPath:@"netWorkState"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    // 设置所有导航栏的颜色
//    [[UINavigationBar appearance] setBarTintColor:NaviBackColor];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
//    NSLog(@"%s",__func__);
//    debugMethod();

    // 设置启动页面时间
//    [NSThread sleepForTimeInterval:0.5];
    // 1.创建窗口
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    
//    // 2.创建窗口的根控制器
//    tabBarVC = [[BaseTabBarViewController alloc] init];
//    tabBarVC.view.backgroundColor = [UIColor clearColor];
//    
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiduMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
//
//    self.window.rootViewController = tabBarVC;
//    // 3.显示窗口
//    [self.window makeKeyAndVisible];
    
    
    [self judgeNetWorkStation];
    [self umengTrack];  //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self shareSDKSetting];
//    [self aliHotfixSetting];   // 阿里百川热更新
    [self addIQKeyboardManager];    // 开启键盘监听功能
//    [[[IQKeyboardManager sharedManager] disabledDistanceHandlingClasses] addObject:[PublishScrollViewViewController class]];
    return YES;
}

- (void)addIQKeyboardManager {
    IQKeyboardManager *manager = IQKEYBOARDMANAGER;
    manager.enable = YES;   // 开启整个功能
    manager.shouldResignOnTouchOutside = YES;   // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;  // 控制键盘上的工具条颜色是否用户自定义。
    manager.enableAutoToolbar = YES; // 控制键是否显示盘上的工具条
    
}

/**
 *  网络监听
 */
- (void)judgeNetWorkStation {
    
    // 添加网络状态 netWorkState 的监听，观察者是 BaseTabBarViewController 
    [self addObserver:tabBarVC forKeyPath:@"netWorkState" options:NSKeyValueObservingOptionNew context:nil];
    
    // 创建网络监听管理对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 开始监听
    [manager startMonitoring];
    // 设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        /*
         typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
         AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
         AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
         AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
         AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
         };
         */
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                self.netWorkState = @"没有连接网络";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                self.netWorkState = @"蜂窝数据";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                self.netWorkState = @"Wifi 网络";
            }
                break;
            default:
            {
                self.netWorkState = @"未识别网络";
            }
                break;
        }
    }];
    
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
#pragma mark - 友盟 配置
- (void)umengTrack {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];//app的build号
    [MobClick setAppVersion:build]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setCrashReportEnabled:YES];  // 自行关闭或开启错误报告功能（默认开启）
    [MobClick setLogEnabled:YES];   // 上架的时候就要关掉
    UMConfigInstance.appKey = @"584e4ca699f0c7382000025d";
    UMConfigInstance.channelId = @"App Store";
    
//    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

#pragma mark - shareSDK mob setting
- (void)shareSDKSetting {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1ab8e82fb3108"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WXAppID
                                       appSecret:WXSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQAppID
                                      appKey:QQKey
                                    authType:SSDKAuthTypeBoth];
                 break;
             
             default:
                 break;
         }
     }];

//(注意：每一个case对应一个break不要忘记填写，不然很可能有不必要的错误，新浪微博的外部库如果不要客户端分享或者不需要加关注微博的功能可以不添加，否则要添加，QQ，微信，google＋这些外部库文件必须要加)
}
/// 阿里百川热修复
//- (void)aliHotfixSetting {
//    
//    NSString *rsaKey = @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCp+ga5zUSZPlVqPZXeLvRkBOUEPHjKhj6MBg1LjSo0vgli98n4bNz3GoPbFjSCucG9RZsszgdwi2Bu2n2+TZyCRGPTaUK1nJ38qYmBtUsZ3iNKGFzXxY13HOvQfB5oxA/nMHZ0XH9WM5PG4phGfDsQW+OYbnjmKEA95LTe47EVGYLF8NakKA0ljHwMfNqjVXnJKF63MRVK+E3Gt24gDoXbWZmQRsnQuE00lBRUKiA32K1Eg3/+uL964bxrNoIfY5gfQObMInkfKJ8G4BqnYYmpVDPzIvyy8+EDbXSCLjTwIk9ex14el5C1kOjCc+TRYx4Rk/5go5k4vZqs1PPHLIiTAgMBAAECggEACJmyBWyxb9+Litia4KcXjogA3noA0p6AQ616trvpysliyDMpcPxxIb+htFAnUAX+G4mOFHJIRhWHR5SekCZ1KNI1CtlkmrPV+pbJclqt9h0bRAB/khtY0RIRjHb7QunItDXriG+1sbLiY0nL0qUuh+FeXrQYQez/cyJDVJPIvfx7WWBeibfQVmFFoMf5g41moNLfwS8WaCQ4lZ4MAbgO1FnuKowBpXAwol4/OwLkER3FORePlYJI7W05T+j8Stn2aN8qT3MTRTNOeWF00zDpb/HjJV7uXSKfdeCnRtRtxsLgy1VJG0tSrcjrBhgAj/bA2wQIADjpvSkMhMZPxlpW4QKBgQDRGeJZ26iuKwmkaAI8gKh51EaEf13hJTAj2tgp0A/RN0lEHVL1F+8tzHWqBq4w4mE4COnMZa7uVoHGonGULcDHcmKe5Pjyk34dZh38dxMqhlUqKcElBzCilcLCqGj7KbYb4E9Hq5+RlPR3bLdbCpoGvnyBD1VIH4lwZrr5T01iVwKBgQDQGbRSn9zHzZwp72UiCDPHlQlVvGRfv6xQsGDXA2f3T7N/aOcnrdXuugnpH+0Ha48OLfPSFkTrabCn4K3A3u7+KOL54c43x2Ab+lE7yLjcchpIiBBWlcLjmdE00v/aG5o/XeJIbk2xOQmykbhRk5OavUCi+Oq629hR+BBc7Q3+JQKBgAPxjQdM0T2XqjLjk0c41fSWQE43aLnaTbIfanw/ZEz50fPq6amdrfEbLgzq21YortSztlUYhdgQ4Zmxbprw0fXw/lMo1lkc1wAO8PnV9RKUPf7xkqb0H8KxOF8bdf9mpfyYmmYronLIcGPgNQUOiiEebpKwi1c04Q6xoU0aZcc5AoGBALEcz25rBNtA0aKXT3nRhVBeNh20Q7GCTsQ1+ZXGHlxMhzbvL52DxEp0KC8zrubb0lt9HME3ltzNjT60aO14T+wdHGEUoBC1LcViHHVHdp6Ytmn48/7dY4uWxImy83LMf1FjNE31I0ashuZmQ3uaoMvYOwT52b3Dkq7g8/xC/d/JAoGANoE36vJ/FKqWWf8iI0WOlZdnqBnAUrXPLtQaRKno9EMs2JAeKBNvRcC0I1LR+Mk4lcLY73NyFWHqPqizHJeTowJNZLcgOP3pKDn9mWnF7Q5FDpcEcVpEUMFCBey5qHJ8hMgQgmtqrciMUFOfZTaQ8mVFQ93Oj2bqp4pjOnHJh00=";
//    
//    char aesEncryptKeyBytes[] = {-37,-61,62,-61,106,69,-11,-58,-6,-22,-12,-87,-15,-66,43,68};
//    NSData *aesEncryptKeyData = [NSData dataWithBytes:aesEncryptKeyBytes length:sizeof(aesEncryptKeyBytes)];
//    char rsaPublicDerBytes[]={48,-126,2,1,48,-126,1,106,2,9,0,-11,119,-123,-123,-70,-87,62,42,48,13,6,9,42,-122,72,-122,-9,13,1,1,5,5,0,48,69,49,11,48,9,6,3,85,4,6,19,2,65,85,49,19,48,17,6,3,85,4,8,19,10,83,111,109,101,45,83,116,97,116,101,49,33,48,31,6,3,85,4,10,19,24,73,110,116,101,114,110,101,116,32,87,105,100,103,105,116,115,32,80,116,121,32,76,116,100,48,30,23,13,49,55,48,51,48,50,48,56,48,50,49,50,90,23,13,50,55,48,50,50,56,48,56,48,50,49,50,90,48,69,49,11,48,9,6,3,85,4,6,19,2,65,85,49,19,48,17,6,3,85,4,8,19,10,83,111,109,101,45,83,116,97,116,101,49,33,48,31,6,3,85,4,10,19,24,73,110,116,101,114,110,101,116,32,87,105,100,103,105,116,115,32,80,116,121,32,76,116,100,48,-127,-97,48,13,6,9,42,-122,72,-122,-9,13,1,1,1,5,0,3,-127,-115,0,48,-127,-119,2,-127,-127,0,-66,-30,-12,83,79,27,-10,104,13,31,-2,120,72,-40,-90,-64,-84,-98,-48,14,117,47,18,-56,69,54,-45,-16,105,119,82,30,-7,47,-1,55,54,37,126,100,6,124,105,39,122,18,41,84,97,12,-70,-105,111,45,-22,-6,126,-57,-99,85,15,-106,-91,-78,119,110,101,-77,-54,-93,-65,-56,-57,-22,-88,-16,57,29,-118,106,100,-77,86,42,51,-87,72,-120,42,67,124,-41,-67,20,6,51,51,-52,37,23,-40,79,25,35,114,43,23,-49,86,32,58,29,-12,-100,53,124,45,-122,-115,-44,-46,-90,96,80,-8,6,-28,103,2,3,1,0,1,48,13,6,9,42,-122,72,-122,-9,13,1,1,5,5,0,3,-127,-127,0,84,-86,-87,28,46,-5,-113,-85,80,70,42,-10,56,26,-53,108,-75,126,55,84,-58,99,-78,-40,-41,105,-119,126,-116,81,-112,109,-103,74,102,-26,-64,-115,90,90,116,-4,-40,106,121,-108,-110,7,-119,13,56,-4,-13,-78,22,-27,36,-63,-106,-10,60,-22,-28,77,-95,30,7,49,9,92,22,-98,0,-81,46,-109,53,4,96,-24,-17,-128,-89,-44,96,-78,-47,21,14,-78,-85,18,47,-79,-13,-20,36,-42,80,73,14,-26,-3,-121,84,49,34,61,66,104,-4,56,-101,49,-83,39,102,11,106,105,13,-81,0,112,57,-18,90,72};
//    NSData *rsaPublicDerData = [NSData dataWithBytes:rsaPublicDerBytes length:sizeof(rsaPublicDerBytes)];
//    
//    [AliHotFix startWithAppID:@"97717-2" secret:@"cc2de86fb6f5998ed9d67341f6300d60" privateKey:rsaKey publicKey:aesEncryptKeyData encryptAESKey:rsaPublicDerData];
//}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0){
// no equiv. notification. return NO if the application can't open for some reason
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


@end

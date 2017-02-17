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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor redColor];
    
    // 2.创建窗口的根控制器
    tabBarVC = [[BaseTabBarViewController alloc] init];
    tabBarVC.view.backgroundColor = [UIColor clearColor];
    
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiduMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window.rootViewController = tabBarVC;
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    
    [self judgeNetWorkStation];
    [self umengTrack];  //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self shareSDKSetting];
    return YES;
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

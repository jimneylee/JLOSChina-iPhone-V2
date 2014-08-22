//
//  JLAppDelegate.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAppDelegate.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MTStatusBarOverlay.h"
#import "LTUpdate.h"
#import "JLNetworkSpy.h"

#import "OSCTabBarC.h"
#import "OSCHomeC.h"
#import "OSCTweetC.h"
#import "OSCForumC.h"
#import "OSCMineC.h"
#import "OSCAboutAppC.h"

@interface OSCAppDelegate()<RCNetworkSpyDelegate>

@end

@implementation OSCAppDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareBeforeLaunching
{
    // Disk cache
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    // AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareAfterLaunching
{
    // New version check
    [[LTUpdate shared] update];
    
    // Spy network
    [[JLNetworkSpy sharedNetworkSpy] spyNetwork];
    [JLNetworkSpy sharedNetworkSpy].spyDelegate = self;
    
    [self appearanceChange];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)appearanceChange
{
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

    UIView* bgView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    bgView.backgroundColor = [UIColor whiteColor];
    // above statusBarBackgroundImageView
    [[MTStatusBarOverlay sharedOverlay] addSubviewToBackgroundView:bgView atIndex:1];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self prepareBeforeLaunching];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#if 1
    
    UITabBarController *tabbarC = [[UITabBarController alloc] init];
    tabbarC.viewControllers = [self generateViewContrllers];
    self.window.rootViewController = tabbarC;
    [self.window makeKeyAndVisible];
    
    [self prepareAfterLaunching];
    
#else// for screenshot
    RCAboutAppC* c = [[RCAboutAppC alloc] initWithNibName:@"RCAboutAppC" bundle:nil];
    self.window.rootViewController = c;
    [self.window makeKeyAndVisible];
#endif
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray *)generateViewContrllers
{
    OSCHomeC *homeC = [[OSCHomeC alloc] initWithStyle:UITableViewStylePlain];
    homeC.tabBarItem.image = [UIImage imageNamed:@"tab_info.png"];
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:homeC];
    navi1.navigationBar.tintColor = [UIColor darkGrayColor];
    
    OSCTweetC *tweetC = [[OSCTweetC alloc] initWithStyle:UITableViewStylePlain];
    tweetC.tabBarItem.image = [UIImage imageNamed:@"tab_tweet.png"];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:tweetC];
    navi2.navigationBar.tintColor = [UIColor darkGrayColor];
    
    OSCForumC *forumC = [[OSCForumC alloc] initWithStyle:UITableViewStylePlain];
    forumC.tabBarItem.image = [UIImage imageNamed:@"tab_answer.png"];
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:forumC];
    navi3.navigationBar.tintColor = [UIColor darkGrayColor];
    
    OSCMineC *mineC = [[OSCMineC alloc] initWithStyle:UITableViewStylePlain];
    mineC.tabBarItem.image = [UIImage imageNamed:@"tab_active.png"];
    UINavigationController *navi4 = [[UINavigationController alloc] initWithRootViewController:mineC];
    navi4.navigationBar.tintColor = [UIColor darkGrayColor];
    
    return [NSMutableArray arrayWithObjects:
            navi1, navi2, navi3, navi4, nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RCNetworkSpyDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didNetworkChangedReachable:(BOOL)reachable viaWifi:(BOOL)viaWifi
{
    NSString* title = @"网络未连接";
    
    if (!reachable) {
        title = @"网络未连接";
    }
    else if (viaWifi) {
        title = @"当前wifi已连接";
    }
    else {
        title = @"当前2g/3g已连接";
    }
    // TODO: 4g is long long after
    [OSCGlobalConfig HUDShowMessage:title addedToView:[UIApplication sharedApplication].keyWindow];
}

@end

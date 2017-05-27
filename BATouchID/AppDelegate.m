//
//  AppDelegate.m
//  BATouchID
//
//  Created by boai on 2017/5/24.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "AppDelegate.h"
#import "BATouchID.h"
#import "BATouchIDLoginVC.h"

#import "NSString+BAKit.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
        
    [self checkIsAlreadyOpenTouchIDIsStart:YES];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [kUserDefaults setObject:[NSDate date] forKey:kLastEnterBackgroundDate];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [self test];
}

- (void)test
{
    NSDate *date = [kUserDefaults objectForKey:kLastEnterBackgroundDate];
    
    // 进入后台 10 秒后需要重新验证指纹
    if (!date || [[NSString ba_intervalSinceNow:date] floatValue] > 1*3)
    {
        [self checkIsAlreadyOpenTouchIDIsStart:NO];
    }
}

- (void)checkIsAlreadyOpenTouchIDIsStart:(BOOL)isStart
{
    id isLogin = [kUserDefaults objectForKey:kIsLogin];
    id isOpenTouchID = [kUserDefaults objectForKey:kIsOpenTouchID];
    
    if ([isLogin intValue] == 1)
    {
        if ([isOpenTouchID intValue] == 1)
        {
            
            BATouchIDLoginVC *vc = [BATouchIDLoginVC new];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
            if (isStart)
            {
                vc.isStart = YES;
                [[UIApplication sharedApplication].windows lastObject].rootViewController = navi;
            }
            else
            {
                [self.window.rootViewController presentViewController:navi animated:NO completion:nil];
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

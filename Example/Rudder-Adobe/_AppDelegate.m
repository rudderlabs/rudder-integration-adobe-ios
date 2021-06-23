//
//  _AppDelegate.m
//  Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import "_AppDelegate.h"
#import <Rudder/Rudder.h>
#import <RudderAdobeFactory.h>
#import <CoreLocation/CoreLocation.h>

@interface _AppDelegate () <CLLocationManagerDelegate>
@property(nonatomic) CLLocationManager *locationManager;
@end

@implementation _AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *WRITE_KEY = @"1s4gjAsjU2O41t6JwCGsCgZf6sg";
    NSString *DATA_PLANE_URL = @"https://8b2e94cad5ff.ngrok.io";
    
    RSConfigBuilder *configBuilder = [[RSConfigBuilder alloc] init];
    [configBuilder withDataPlaneUrl:DATA_PLANE_URL];
    [configBuilder withControlPlaneUrl:@"https://fcc1cb53a2cd.ngrok.io"];
    //[configBuilder withLoglevel:RSLogLevelDebug];
    [configBuilder withFactory:[RudderAdobeFactory instance]];
    // [configBuilder withTrackLifecycleEvens:false];
    [RSClient getInstance:WRITE_KEY config:[configBuilder build]];
    
    
    NSMutableDictionary<NSString *, id> *products1 = [NSMutableDictionary<NSString *, id> dictionary];
    [products1 setObject: @"Games"  forKey: @"category"];
    [products1 setObject: @"1234" forKey: @"id"];
    [products1 setObject: @"20" forKey: @"quantity"];
    [products1 setObject: @"5001" forKey: @"price"];
    [products1 setObject: @"Abhishek" forKey: @"name"];

    NSMutableDictionary<NSString *, id> *products2 = [NSMutableDictionary<NSString *, id> dictionary];
    [products2 setObject: @"Games"  forKey: @"category"];
    [products2 setObject: @"1234" forKey: @"product_id"];
    [products2 setObject: @"20" forKey: @"quantity"];
    [products2 setObject: @"5001" forKey: @"price"];
    
    NSMutableArray<NSObject *>* product = [NSMutableArray array];
    [product addObject: products1];
    [product addObject: products2];
    
    [[RSClient sharedInstance] track:@"Product Added" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

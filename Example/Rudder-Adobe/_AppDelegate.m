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
    
    
    
//    [[RSClient sharedInstance] identify:@"iOS_user_new"];
//    [[RSClient sharedInstance] track:@"Order Completed" properties:@{
//        @"revenue" : @1001,
//        @"orderId" : @"1001",
//        @"currency" : @"USD",
//        @"custom_1" : @"1custom",
//        @"custom_2" : @1345,
//        @"products" : @[
//                @{
//                    @"category" : @"11Cloths",
//                    @"product_id" : @"100001",
//                    @"name": @"11Shirt",
//                    @"price" : @101,
//                    @"quantity" : @11
//                },
//                @{
//                    @"category" : @"12Cloths",
//                    @"product_id" : @"100002",
//                    @"name": @"12shirt",
//                    @"price" : @102,
//                    @"quantity" : @12
//                }
//        ]
//    }];
//
//    [[RSClient sharedInstance] track:@"Order Completed" properties:@{
//        @"revenue" : @1001,
//        @"orderId" : @"1001",
//        @"currency" : @"USD",
//        @"custom_1" : @"1custom",
//        @"custom_2" : @1345,
//        @"category" : @"11Cloths",
//        @"productId" : @"100001",
//        @"name": @"11Shirt",
//        @"price" : @101,
//        @"quantity" : @11
//    }];
//
//    [[RSClient sharedInstance] track:@"Product Added"
//                          properties:@{
//                              @"productId" : @"200001",
//                              @"name": @"21Bag",
//                              @"quantity" : @21,
//                              @"price" : @201,
//                              @"custom_1" : @"2custom"
//                          }];
//
//    [[RSClient sharedInstance] track:@"Checkout Started"
//                          properties:@{
//                              @"revenue" : @3001,
//                              @"orderId" : @3001,
//                              @"currency" : @"USD",
//                              @"custom_1" : @"3custom",
//                              @"custom_2" : @3345,
//                              @"products" : @[
//                                      @{
//                                          @"category" : @"31Cloths",
//                                          @"product_id" : @300001,
//                                          @"name": @"31Shirt",
//                                          @"price" : @301,
//                                          @"quantity" : @31
//                                      },
//                                      @{
//                                          @"category" : @"32Cloths",
//                                          @"product_id" : @"300002",
//                                          @"name": @"32shirt",
//                                          @"price" : @302,
//                                          @"quantity" : @32
//                                      }
//                              ]
//                          }];
//
//    [[RSClient sharedInstance] track:@"Checkout Started"
//                          properties:@{
//                              @"custom_2" : @32345,
//                              @"products" : @[
//                                      @{
//                                          @"product_id" : @3200001,
//                                          @"name": @"33Shirt",
//                                          @"price" : @301
//                                      },
//                                      @{
//                                          @"product_id" : @"3200002",
//                                          @"name": @"34shirt",
//                                          @"quantity" : @32
//                                      }
//                              ]
//                          }];
//    
//    [[RSClient sharedInstance] track:@"Checkout Started"
//                          properties:@{
//                              @"custom_2" : @32345,
//                          }];
//
//    [[RSClient sharedInstance] track:@"cart viewed"
//                              properties:@{
//                                  @"custom_2" : @4345,
//                              }];
//
//    [[RSClient sharedInstance] track:@"product removed"
//                              properties:@{
//                                  @"custom_2" : @5345,
//                              }];
//
//    [[RSClient sharedInstance] track:@"product viewed"
//                              properties:@{
//                                  @"custom_2" : @6345,
//                              }];
//
//    [[RSClient sharedInstance] track:@"myapp.ActionName"
//                              properties:@{
//                                  @"custom_2" : @72345,
//                              }];
//
//    [[RSClient sharedInstance] screen:@"screen_call"
//                                  properties:@{
//                                      @"custom_2" : @82345,
//                                  }];
//
    //--------------------------------------------------------------------------------
    
    
    /*
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
    
    [[RSClient sharedInstance] track:@"product removed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"cart viewed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"checkout started" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"order completed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"product viewed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    */
    
    
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


/*
 
 Rudder-Adobe_Example[26725:4783087] ADBMobile Debug: Analytics - Successfully sent hit(ndh=1&t=00%2F00%2F0000%2000%3A00%3A00%200%20-330&c.&orderId=1001&products=%7B%0A%20%20%20%20category%20%3D%2011Cloths%3B%0A%20%20%20%20name%20%3D%2011Shirt%3B%0A%20%20%20%20price%20%3D%20101%3B%0A%20%20%20%20productId%20%3D%20100001%3B%0A%20%20%20%20quantity%20%3D%2011%3B%0A%7D%2C%7B%0A%20%20%20%20category%20%3D%2012Cloths%3B%0A%20%20%20%20name%20%3D%2012shirt%3B%0A%20%20%20%20price%20%3D%20102%3B%0A%20%20%20%20%22product_id%22%20%3D%20100002%3B%0A%20%20%20%20quantity%20%3D%2012%3B%0A%7D&custom_2=1345&revenue=1001&custom_1=1custom&a.&action=myapp.ActionName&OSVersion=iOS%2014.5&DeviceName=x86_64&RunMode=Application&AppID=Rudder-Adobe_Example%201.0%20%281.0%29&CarrierName=%28null%29&Resolution=1170x2532&TimeSinceLaunch=5&.a&currency=USD&.c&mid=52105007788800746111447584121836330116&pev2=AMACTION%3Amyapp.ActionName&ts=1624449697&pageName=Rudder-Adobe_Example%2F1.0&vid=iOS_user&pe=lnk_o&ce=UTF-8&cp=foreground)
 
 
 */
